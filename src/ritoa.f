      SUBROUTINE RITOA(STRING,SC,LEN,RINT,REM,IERR)
      INCLUDE 'syspar.d'
C
C     CONVERT THE INTEGER PARTOF A DOUBLE (RINT) TO ASCII-TEXT (STRING)
C     IF IT WILL NOT FIT RETURN IERR > 0
C
C     STRING....REPOSITORY FOR TEXT OF INT
C     SC .......STARTING CHARACTER POS
C     LEN ......LENGHT OF STRING
C     RINT......REAL TO CONVERT (MAY BE LARGER THAN MAX INT)
C     REM ......DECIMAL PART OF RINT
C     IERR......0 IF RINT FITS, 1 OTHERWISE
C
      DOUBLE PRECISION RINT, REM
 
      INCLUDE 'ascpar.d'
      INCLUDE 'lxlcom.d'
 
      DOUBLE PRECISION R
C
      IERR = 0
      R = DABS(RINT)
      DG = IEXP(R)
      IF (DG.GT.LEN) GOTO 800
      S = SC + LEN - DG - 1
      IF (RINT.LT.0) THEN
         IF (S.LT.SC) GOTO 800
         CALL PUTT(STRING,S,MNSIGN)
      ENDIF
C
      DO 100 I = 1, DG
      E = DG - I
      IN = R / (10.0D0**E)
      IF (IN.GT.9) IN = 9
      CALL PUTT(STRING,S+I,IN+U0)
      R = R - IN*(10.0D0**E)
100   CONTINUE
      REM = R
101   RETURN
 
C     NUMBER TOO BIG
 
800   IERR = 1
      RETURN
      END
