

CREATE TABLE `my_videos` (
  `name` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  `uploaded_timestamp` timestamp NOT NULL,
  `number_of_views` int NOT NULL,
  `number_of_likes` int NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE DEFINER=`openpm_app`@`%` FUNCTION `getApplied`(`rcptnum` INT) RETURNS decimal(20,2)
DETERMINISTIC
COMMENT 'from t_receipt.getApplied()'
BEGIN DECLARE amt DECIMAL(20,2); DECLARE disbursed VARCHAR(10); DECLARE rectype VARCHAR(2); DECLARE recamt DECIMAL(20,2);  SELECT r.disbursed,r.recamt,r.rectype INTO disbursed, recamt, rectype FROM receipt r WHERE r.rcptnum=rcptnum;  IF disbursed IS NOT NULL AND disbursed != '' THEN SET amt = recamt; ELSEIF rectype='PC' THEN SET amt = ( SELECT IFNULL(SUM(CASE WHEN p.trtype IN ('PP','PPC','PCA') THEN p.amt WHEN p.trtype='PD' THEN -p.amt ELSE 0 END),0.00) FROM receipt r, payline p WHERE r.rcptnum=p.rcptnum AND r.rcptnum=rcptnum ); ELSEIF rectype='PR' THEN SET amt = ( SELECT IFNULL(SUM(CASE WHEN p.trtype IN ('PRF') THEN p.amt ELSE 0 END),0.00) FROM receipt r, payline p WHERE r.rcptnum=p.rcptnum AND r.rcptnum=rcptnum ); ELSEIF rectype='IR' THEN SET amt = ( SELECT IFNULL(SUM(CASE WHEN p.trtype IN ('IRF') THEN p.amt WHEN p.trtype IN ('IP') THEN -p.amt ELSE 0 END),0.00) FROM receipt r, payline p WHERE r.rcptnum=p.rcptnum AND r.rcptnum=rcptnum ); ELSE SET amt = ( SELECT IFNULL(SUM(CASE WHEN f.type = 'C' OR p.trtype IN ('PPC','IPC') THEN p.amt WHEN f.type = 'D' THEN -p.amt ELSE 0 END),0.00) FROM receipt r, payline p, fintr f WHERE r.rcptnum=p.rcptnum AND f.code=p.trtype AND r.rcptnum=rcptnum AND (f.grp IN ('IP','PP') OR p.trtype IN ('PPC','IPC')) );  END IF;  RETURN amt; END;

use updocm;

routines

CREATE DEFINER=`fero`@`%` FUNCTION `tcase`( str VARCHAR(128) ) RETURNS varchar(128) CHARSET latin1
DETERMINISTIC
BEGIN
  DECLARE c CHAR(1);
  DECLARE s VARCHAR(128);
  DECLARE i INT DEFAULT 1;
  DECLARE bool INT DEFAULT 1;
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';
  SET s = LCASE( str );
  WHILE i <= LENGTH( str ) DO
  BEGIN
  SET c = SUBSTRING( s, i, 1 );
  IF LOCATE( c, punct ) > 0 THEN
  SET bool = 1;
  ELSEIF bool=1 THEN
  BEGIN
  IF c >= 'a' AND c <= 'z' THEN
  BEGIN
  SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));
  SET bool = 0;
  END;
  ELSEIF c >= '0' AND c <= '9' THEN
  SET bool = 0;
  END IF;
  END;
  END IF;
  SET i = i+1;
  END;
  END WHILE;

  SET s = lowerword(s, 'A');
  SET s = lowerword(s, 'An');
  SET s = lowerword(s, 'And');
  SET s = lowerword(s, 'As');
  SET s = lowerword(s, 'At');
  SET s = lowerword(s, 'But');
  SET s = lowerword(s, 'By');
  SET s = lowerword(s, 'For');
  SET s = lowerword(s, 'If');
  SET s = lowerword(s, 'In');
  SET s = lowerword(s, 'Of');
  SET s = lowerword(s, 'On');
  SET s = lowerword(s, 'Or');
  SET s = lowerword(s, 'The');
  SET s = lowerword(s, 'To');
  SET s = lowerword(s, 'Via');

  RETURN s;
END;

