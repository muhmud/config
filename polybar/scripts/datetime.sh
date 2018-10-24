#!/bin/bash

DaySuffix() {
  case $(( 10#$1 )) in
    1|21|31) echo "st";;
    2|22)    echo "nd";;
    3|23)    echo "rd";;
    *)       echo "th";;
  esac
}

TimeSeparator() {
  if [ $(( 10#`date +"%S"` % 2 )) -eq 0 ]; then
    echo ":"
  else
    echo " "
  fi
}

timeSeparator=`TimeSeparator`

function rawTime {
  p=$1
  q=${p/:/}
  echo "1${q:0:4}"
}

function asTime {
  tRaw=$1
  echo "${tRaw:1:2}:${tRaw:3:2}"
}

function addMinutes {
  tRaw=$1
  mins=$2
  hour="${tRaw:1:2}"
  minute="${tRaw:3:2}"
  minute=$((10#$minute + $mins))
  if [[ $minute -gt 59 ]]; then
    let minute-=60
    let hour+=1
  fi

  printf "1%02d%02d" $hour $minute
}

function chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

timesFile=/tmp/esolat.json
times=`cat $timesFile 2>/dev/null`
if [[ ! -z $times ]]; then
    islamicDate=`echo $times | jq -r '.prayerTime[0].hijri'`
    islamicDay=`echo ${islamicDate:8:2}`
    islamicMonth=`echo ${islamicDate:5:2}`
    case $islamicMonth in
      "01")
        islamicMonthName="Muharram"
        ;;
      "02")
        islamicMonthName="Safar"
        ;;
      "03")
        islamicMonthName="Rabi Al-Awwal"
        ;;
      "04")
        islamicMonthName="Rabi Al-Thani"
        ;;
      "05")
        islamicMonthName="Jumada Al-Ula"
        ;;
      "06")
        islamicMonthName="Jumada Al-Akhirah"
        ;;
      "07")
        islamicMonthName="Rajab"
        ;;
      "08")
        islamicMonthName="Shaban"
        ;;
      "09")
        islamicMonthName="Ramadan"
        ;;
      "10")
        islamicMonthName="Shawwal"
        ;;
      "11")
        islamicMonthName="Dhu Al-Qadah"
        ;;
      "12")
        islamicMonthName="Dhu Al-Hijjah"
        ;;
    esac

    islamicYear=`echo ${islamicDate:0:4}`
    islamicDayNumber=$((10#$islamicDay))
    if [[ $islamicDayNumber == 14 || $islamicDayNumber == 15 || $islamicDayNumber == 16 ]]; then
        islamicDayFormatStart="%{u#ffffff +u}%{F#fff}"
        islamicDayFormatEnd="%{-u}%{F-}"
    fi

    if [[ $islamicDayNumber == 29 || $islamicDayNumber == 30 ]]; then
        moon="%{T3}A%{T-}"
    elif [[ $islamicDayNumber == 14 || $islamicDayNumber == 15 || $islamicDayNumber == 16 ]]; then
        moon="%{F#fff}%{T3}0%{T-}%{F-}"
    elif [[ $islamicDayNumber -ge 1 && $islamicDayNumber -le 13 ]]; then
        moon="%{T3}`chr $((78 + $islamicDayNumber - 1))`%{T-}"
    elif [[ $islamicDayNumber -ge 17 && $islamicDayNumber -le 28 ]]; then
        moon="%{T3}`chr $((76 - $islamicDayNumber + 17))`%{T-}"
    fi
    
    todayIslamic=" $(echo -e $islamicDayFormatStart)$((10#$islamicDay))`DaySuffix $islamicDay`$(echo -e $islamicDayFormatEnd) $islamicMonthName $islamicYear /"
    

    serverTime=`echo $times | jq -r '.serverTime'`
    timeRaw=`rawTime $(date +%H:%M)`

    calendarDate=`echo $times | jq -r '.prayerTime[0].date'`

    imsak=`echo $times | jq -r '.prayerTime[0].imsak'`
    imsakRaw=`rawTime $imsak`
    fajr=`echo $times | jq -r '.prayerTime[0].fajr'`
    fajrRaw=`rawTime $fajr`
    syuruk=`echo $times | jq -r '.prayerTime[0].syuruk'`
    syurukRaw=`rawTime $syuruk`
    dhuhr=`echo $times | jq -r '.prayerTime[0].dhuhr'`
    dhuhrRaw=`rawTime $dhuhr`
    asr=`echo $times | jq -r '.prayerTime[0].asr'`
    asrRaw=`rawTime $asr`
    maghrib=`echo $times | jq -r '.prayerTime[0].maghrib'`
    maghribRaw=`rawTime $maghrib`
    isha=`echo $times | jq -r '.prayerTime[0].isha'`
    ishaRaw=`rawTime $isha`

    duhaRaw=`addMinutes $syurukRaw 20`
    duha=`asTime $duhaRaw`
    
    thisColour="%{F#0f0}"
    nextColour="%{F#f03}"
    nowColour="%{F#ff0}"
    mildColour="%{F#0ff}"
    clear="%{F-}"

    tahajudRaw="$(($fajrRaw - 100))"
    tahajud=`asTime $tahajudRaw`

    if [[ "`date +"%a"`" == "Fri" ]]; then
        afternoonPrayer="Jumuah"
        afternoonPrayerBlank="             "
        afternoonPrayerColour="%{F#fff}"
        afternoonPrayerEnd=`addMinutes $dhuhrRaw 30`
        afternoonPrayerEnd=`addMinutes $afternoonPrayerEnd 30`
        afternoonPrayerEnd=`addMinutes $afternoonPrayerEnd 30`
        afternoonPrayerEnd=`addMinutes $afternoonPrayerEnd 30`
    else
        afternoonPrayer="Dhuhr"
        afternoonPrayerBlank="            "
        afternoonPrayerColour=$mildColour
        afternoonPrayerEnd=$asrRaw
    fi
    
    if [[ "$timeRaw" -ge "$tahajudRaw" && "$timeRaw" -lt "$fajrRaw" ]]; then
      if [[ "$timeRaw" -eq "$tahajudRaw" ]]; then
          prayerCurrent="Tahajud: ${tahajud:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="              "
          fi
      else
          prayerCurrent="Tahajud$clear (${tahajud:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $nextColour)Fajr: ${fajr:0:5}$clear"
    elif [[ "$timeRaw" -ge "$fajrRaw" && "$timeRaw" -lt "$syurukRaw" ]]; then
      if [[ "$timeRaw" -eq "$fajrRaw" ]]; then
          prayerCurrent="Fajr: ${fajr:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="           "
          fi
      else
          prayerCurrent="Fajr$clear (${fajr:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $nextColour)Syuruk: ${syuruk:0:5}$clear"
    elif [[ "$timeRaw" -ge "$syurukRaw" && "$timeRaw" -lt "$duhaRaw" ]]; then
      thisColour=$nextColour
      if [[ "$timeRaw" -eq "$syurukRaw" ]]; then
          prayerCurrent="Syuruk: ${syuruk:0:5}"
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="             "
          fi
      else
          prayerCurrent="Syuruk$clear (${syuruk:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $mildColour)Duha: ${duha:0:5}$clear"
    elif [[ "$timeRaw" -ge "$duhaRaw" && "$timeRaw" -lt "$dhuhrRaw" ]]; then
      if [[ "$timeRaw" -eq "$duhaRaw" ]]; then
          prayerCurrent="Duha: ${duha:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="           "
          fi
      else
          prayerCurrent="Duha$clear (${duha:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $afternoonPrayerColour)$afternoonPrayer: ${dhuhr:0:5}$clear"
    elif [[ "$timeRaw" -ge "$dhuhrRaw" && "$timeRaw" -lt "$asrRaw" ]]; then
      if [[ "$timeRaw" -eq "$dhuhrRaw" ]]; then
          prayerCurrent="$afternoonPrayer: ${dhuhr:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent=$afternoonPrayerBlank
          fi
      else
          prayerCurrent="$afternoonPrayer$clear (${dhuhr:0:5})"
      fi
      if [[ "$timeRaw" -ge "afternoonPrayerEnd" ]]; then
          prayers=" -  $(echo -e $mildColour)Asr: ${asr:0:5}$clear"
      else
          prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $nextColour)Asr: ${asr:0:5}$clear"
      fi
    elif [[ "$timeRaw" -ge "$asrRaw" && "$timeRaw" -lt "$maghribRaw" ]]; then
      if [[ "$timeRaw" -eq "$asrRaw" ]]; then
          prayerCurrent="Asr: ${asr:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="          "
          fi
      else
          prayerCurrent="Asr$clear (${asr:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $nextColour)Maghrib: ${maghrib:0:5}$clear"
    elif [[ "$timeRaw" -ge "$maghribRaw" && "$timeRaw" -lt "$ishaRaw" ]]; then
      if [[ "$timeRaw" -eq "$maghribRaw" ]]; then
          prayerCurrent="Maghrib: ${maghrib:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="              "
          fi
      else
          prayerCurrent="Maghrib$clear (${maghrib:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $nextColour)Isha: ${isha:0:5}$clear"
    elif [[ "$timeRaw" -ge "$ishaRaw" ]]; then
      if [[ "$timeRaw" -eq "$ishaRaw" ]]; then
          prayerCurrent="Isha: ${isha:0:5}"
          thisColour=$nowColour
          if [[ "$timeSeparator" == " " ]]; then
              prayerCurrent="           "
          fi
      else
          prayerCurrent="Isha$clear (${isha:0:5})"
      fi
      prayers=" -  $(echo -e $thisColour)$prayerCurrent$clear | $(echo -e $mildColour)Tahajud: ${tahajud=:0:5}$clear"
    else
      thisColour=$mildColour
      prayers=" -  $(echo -e $thisColour)Tahajud: ${tahajud=:0:5}$clear"
    fi
fi

date +"$(echo -e "$moon") %a$todayIslamic $(($(date +"%e")))`DaySuffix $(date +"%d")` %B %Y, %H$timeSeparator%M$prayers"

