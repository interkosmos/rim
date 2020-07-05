      SUBROUTINE BTGET(ID,NSTRT)
      INCLUDE 'syspar.d'
C
C  PURPOSE:    RETREIVE OR SET UP A BTREE OR MOT NODE.
C
C  PARAMETERS
C     INPUT:   ID------DESIRED RECORD NUMBER
C     OUTPUT:  NSTRT---BUFFER INDEX FOR REQUESTED NODE
C
      INCLUDE 'btbuf.d'
      INCLUDE 'rimcom.d'
      INCLUDE 'f3com.d'
C
C  SEE IF THE BLOCK IS IN CORE.
C
      DO 100 NUMB=1,NUMIC
      IF(ID.EQ.ICORE(3,NUMB)) GO TO 1000
  100 CONTINUE
C
C  THE REQUESTED BLOCK IS NOT IN THE BUFFER.
C
C   DETERMINE WHICH SLOT IN THE BUFFER WE SHOULD USE.
C
      IF(NUMIC.GE.MAXIC) GO TO 200
C
C  STILL ROOM IN THE BUFFER.
C
      NUMIC = NUMIC + 1
      NUMB = NUMIC
      GO TO 500
C
C  WE MUST DETERMINE WHO WILL BE MOVED OUT.
C
  200 CONTINUE
      MINUMB = 1
      IF(MINUMB.EQ.LAST) MINUMB = 2
      MINUSE = ICORE(1,MINUMB)
      DO 300 NUMB=1,NUMIC
      IF(NUMB.EQ.LAST) GO TO 300
      NUMUSE = ICORE(1,NUMB)
      IF(NUMUSE.EQ.0) GO TO 400
      IF(NUMUSE.GT.MINUSE) GO TO 300
      MINUSE = NUMUSE
      MINUMB = NUMB
  300 CONTINUE
C
C  USE THE BLOCK THAT WAS USED THE LEAST.
C
      NUMB = MINUMB
  400 CONTINUE
C
C  BLOCK NUMB WILL BE USED.
C
C  SEE IF THE BLOCK CURRENTLY THERE MUST BE WRITTEN OUT.
C
      IF(ICORE(2,NUMB).EQ.0) GO TO 500
C
C  WRITE IT OUT.
C
      ISTRT = (NUMB-1) * LENBF3 + 1
      IEND = ISTRT + LENBF3 - 1
      IOBN = ICORE(3,NUMB)
      CALL RIOOUT(FILE3,IOBN,CORE(ISTRT),LENBF3,IOS)
      IF(IOS.NE.0) RMSTAT = 2300 + IOS
  500 CONTINUE
C
C  CHANGE THE ICORE ENTRY.
C
      ICORE(3,NUMB) = ID
      ICORE(2,NUMB) = 0
C
C  READ IN DESIRED BLOCK.
C
      ISTRT = (NUMB-1) * LENBF3 + 1
      CALL RIOIN(FILE3,ID,CORE(ISTRT),LENBF3,IOS)
      IF(ID.GE.LF3REC) GO TO 600
      IF(IOS.EQ.0) GO TO 1000
  600 CONTINUE
      CALL ZEROIT(CORE(ISTRT),LENBF3)
      CALL RIOOUT(FILE3,0,CORE(ISTRT),LENBF3,IOS)
      IF(IOS.NE.0) RMSTAT = 2300 + IOS
C
C  UPDATE THE ICORE ARRAY AND SET NSTRT.
C
 1000 CONTINUE
      ICORE(1,NUMB) = ICORE(1,NUMB) + 1
      ISTRT = ((NUMB-1) * LENBF3) / 3 + 1
      NSTRT = ISTRT
      LAST = NUMB
      RETURN
      END