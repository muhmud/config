#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function usage() {
    echo
    echo "Performs an AWS restore of a database backup"
    echo ""
    echo "Usage: restore-db.sh <source> <source-cluster> <destination> <destination-cluster> <recovery-point-arn>"
    echo ""
    echo "   source                The source environment of the backup to be restored"
    echo "   cluster               The name of the cluster to be restored, e.g. ops8"
    echo "   destination           The destination environment for the restore, i.e. production, staging, test"
    echo "   destination-cluster   The name of the destination cluster"
    echo "   recovery-point-arn    Optional recovery point ARN to be used, defaults to the latest backup"
    echo "   availability-zone     The availability the restore should be done to, defaults to us-east-2a"
    echo ""
}

SOURCE_ENVIRONMENT=$1
if [[ -z "$SOURCE_ENVIRONMENT" ]]; then
    usage;
    exit -1;
fi;

SOURCE_CLUSTER=$2
if [[ -z "$SOURCE_CLUSTER" ]]; then
    usage;
    exit -1;
fi;

DESTINATION_ENVIRONMENT=$3
if [[ -z "$DESTINATION_ENVIRONMENT" ]]; then
    usage;
    exit -1;
fi;

DESTINATION_CLUSTER=$4
if [[ -z "$DESTINATION_CLUSTER" ]]; then
    usage;
    exit -1;
fi;

AVAILABILITY_ZONE=$6
if [[ -z "$AVAILABILITY_ZONE" ]]; then
    AVAILABILITY_ZONE="us-east-2a";
fi;

# Ensure that the source cluster directory exists
SOURCE_DIRECTORY=$DIR/../deployments/$SOURCE_ENVIRONMENT/$SOURCE_CLUSTER
if [[ ! -d $SOURCE_DIRECTORY ]]; then
    echo "Could not find deployment directory for source cluster";
    exit -1;
fi;

# Ensure that the destination cluster directory does not exists
DESTINATION_DIRECTORY=$DIR/../deployments/$DESTINATION_ENVIRONMENT/$DESTINATION_CLUSTER
if [[ -d $DESTINATION_DIRECTORY ]]; then
    echo "Deployment directory already exists";
    exit -1;
fi;

cd $SOURCE_DIRECTORY;

# Find the main database backup volume from terraform
TERRAFORM_DATABASE_BACKUP_VOLUME=$(terraform state list | grep 'module.database.aws_ebs_volume.backup-volume');
if [[ -z $TERRAFORM_DATABASE_BACKUP_VOLUME ]]; then
    echo "Could not find database backup volume in Terraform state";
    exit -1;
fi;

# Store the Terraform state for the database backup volume
TERRAFORM_DATABASE_BACKUP_VOLUME_STATE=$(terraform state show $TERRAFORM_DATABASE_BACKUP_VOLUME);

RECOVERY_POINT_ARN=$5
if [[ -z "$RECOVERY_POINT_ARN" ]]; then
    # Find the ARN for the volume
    DATABASE_BACKUP_VOLUME_ARN=$(echo $TERRAFORM_DATABASE_BACKUP_VOLUME_STATE \
      | grep '[^"]arn' | awk -F '= ' '{ print $2 }' \
      | sed 's/"//g');
    if [[ -z $DATABASE_BACKUP_VOLUME_ARN ]]; then
        echo "Could not find database backup ARN in Terraform state";
        exit -1;
    fi;

    # Find the recovery point ARN for the latest backup
    RECOVERY_POINT_ARN=$(aws backup list-recovery-points-by-resource --resource-arn=$ARN \
      | jq '[.RecoveryPoints[] | select(.Status == "COMPLETED")][0] | .RecoveryPointArn' \
      | sed 's/"//g');
    if [[ -z $RECOVERY_POINT_ARN ]]; then
        echo "Could not find recovery point ARN for the latest database backup";
        exit -1;
    fi;
fi;

SNAPSHOT=$(echo $RECOVERY_POINT_ARN | jq -r '.RecoveryPointArn' | cut -d/ -f2);
if [[ -z "$SNAPSHOT" ]]; then
  echo "Could not determine snapshot name from recovery point arn";
  exit -1;
fi;

export RESTORE_METADATA=$(aws backup get-recovery-point-restore-metadata \
  --recovery-point-arn $RECOVERY_POINT_ARN --backup-vault-name Default \
  | jq "{ \
    encrypted: .RestoreMetadata.encrypted, \
    volumeId: .RestoreMetadata.volumeId, \
    kmsKeyId: .RestoreMetadata.kmsKeyId, \
    availabilityZone: \"$AVAILABILITY_ZONE\" \
  }")

# Perform the restore
RESTORE_DATETIME=$(date +"%F %T.%N");
RESTORE_JOB_ID = $(aws backup start-restore-job \
  --recovery-point-arn $RECOVERY_POINT_ARN \
  --metadata $RESTORE_METADATA \
  --iam-role-arn arn:aws:iam::349646072622:role/service-role/AWSBackupDefaultServiceRole \
  --resource-type EBS \
  --idempotency-token $(uuid) | jq -r '.RestoreJobId');
if [[ -z "$RESTORE_JOB_ID" ]]; then
  echo "Failed to start restore job";
  exit -1;
fi;

# Get the status of the restore job
RESTORE_JOB_STATUS_DATA=$(aws backup describe-restore-job --restore-job-id "$RESTORE_JOB_ID");
RESTORE_JOB_STATUS=$(echo "$RESTORE_JOB_STATUS_DATA" | jq -r '.Status');
if [[ "$RESTORE_JOB_STATUS" == "FAILED" ]]; then
  RESTORE_JOB_STATUS_MESSAGE=$(echo "$RESTORE_JOB_STATUS_DATA" | jq -r '.StatusMessage');
  echo "restore job failed: $RESTORE_JOB_STATUS_MESSAGE";
  exit -1;
fi;

if [[ "$RESTORE_JOB_STATUS" == "RUNNING" ]]; then
  # Find all volumes that were created from our snapshot after we started the restore and are available
  RESTORE_VOLUMES=$(aws ec2 describe-volumes \
    --filters Name=status,Values=available Name=snapshot-id,Values=$SNAPSHOT \
    | jq ".Volumes[] | select(.CreateTime >= \"$RESTORE_DATETIME\")");
    
    
fi;
