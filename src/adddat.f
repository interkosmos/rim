      SUBROUTINE ADDDAT(INDEX,ID,ARRAY,LENGTH)
C
C     ADD A TUPLE TO THE DATA FILE
C
C
C         INDEX   = BLOCK REFERENCE NUMBER
C         ID      = PACKED ID WORD WITH OFFSET,IOBN
C         ARRAY   = ARRAY TO RECEIVE THE TUPLE
C         LENGTH  = LENGTH OF THE TUPLE
C         

      INCLUDE 'syspar.d'
      INCLUDE 'f2com.d'
      INCLUDE 'rimcom.d'
      INCLUDE 'buffer.d'
      INCLUDE 'flags.d'
C
      INTEGER OFFSET
      INTEGER ARRAY(1)
C
C  UNPAC THE ID WORD.
C
      CALL ITOH(OFFSET,IOBN,ID)
C
C  CALCULATE THE NEW ID VALUE.
C
      IF(LF2WRD + LENGTH + 1 .LE. LENBF2) GO TO 100
      LF2REC = LF2REC + 1
      LF2WRD = 1
  100 CONTINUE
      CALL HTOI(LF2WRD,LF2REC,ID)
      IF(IOBN.EQ.0) GO TO 500
C
C  SEE IF THE NEEDED BLOCK IS CURRENTLY IN CORE.
C
      NUMBLK = 0
      DO 200 I=1,3
      IF(IOBN.EQ.CURBLK(I)) NUMBLK = I
  200 CONTINUE
      IF(NUMBLK.NE.0) GO TO 400
      NUMBLK = INDEX
C
C  WE MUST DO PAGING.
C
C  SEE IF THE CURRENT BLOCK NEEDS WRITING.
C
      IF(MODFLG(NUMBLK).EQ.0) GO TO 300
C
C  WRITE OUT THE CURRENT BLOCK.
C
      KQ1 = BLKLOC(NUMBLK)
      CALL RIOOUT(FILE2,CURBLK(NUMBLK),BUFFER(KQ1),LENBF2,IOS)
      IF(IOS.NE.0) RMSTAT = 2200 + IOS
  300 CONTINUE
C
C  READ IN THE NEEDED BLOCK.
C
      CALL BLKCHG(NUMBLK,LENBF2,1)
      KQ1 = BLKLOC(NUMBLK)
      CALL RIOIN(FILE2,IOBN,BUFFER(KQ1),LENBF2,IOS)
      CURBLK(NUMBLK) = IOBN
      IF(IOS.EQ.0) GO TO 400
C
C  WRITE OUT THE RECORD FOR THE FIRST TIME.
C
      CALL ZEROIT(BUFFER(KQ1),LENBF2)
      CALL RIOOUT(FILE2,0,BUFFER(KQ1),LENBF2,IOS)
      IF(IOS.NE.0) RMSTAT = 2200 + IOS
  400 CONTINUE
      MODFLG(NUMBLK) = 1
      IFMOD = .TRUE.
C
C  FIX UP THE ID POINTER SO IT POINTS TO THE NEXT TUPLE.
C
      KQ0 = BLKLOC(NUMBLK) - 1
      ISIGN = 1
      IF(BUFFER(KQ0 + OFFSET).LT.0) ISIGN = -1
      BUFFER(KQ0 + OFFSET) = ISIGN * ID
      MODFLG(NUMBLK) = 1
      IFMOD = .TRUE.
C
C  NOW MOVE THE NEW TUPLE.
C
  500 CONTINUE
      CALL ITOH(OFFSET,IOBN,ID)
C
C  SEE IF THE NEEDED BLOCK IS CURRENTLY IN CORE.
C
      NUMBLK = 0
      DO 600 I=1,3
      IF(IOBN.EQ.CURBLK(I)) NUMBLK = I
  600 CONTINUE
      IF(NUMBLK.NE.0) GO TO 800
      NUMBLK = INDEX
C
C  WE MUST DO PAGING.
C
C  SEE IF THE CURRENT BLOCK NEEDS WRITING.
C
      IF(MODFLG(NUMBLK).EQ.0) GO TO 700
C
C  WRITE OUT THE CURRENT BLOCK.
C
      KQ1 = BLKLOC(NUMBLK)
      CALL RIOOUT(FILE2,CURBLK(NUMBLK),BUFFER(KQ1),LENBF2,IOS)
      IF(IOS.NE.0) RMSTAT = 2200 + IOS
  700 CONTINUE
C
C  READ IN THE NEEDED BLOCK.
C
      CALL BLKCHG(NUMBLK,LENBF2,1)
      KQ1 = BLKLOC(NUMBLK)
      CALL RIOIN(FILE2,IOBN,BUFFER(KQ1),LENBF2,IOS)
      CURBLK(NUMBLK) = IOBN
      IF(IOS.EQ.0) GO TO 800
C
C  WRITE OUT THE RECORD FOR THE FIRST TIME.
C
      CALL ZEROIT(BUFFER(KQ1),LENBF2)
      CALL RIOOUT(FILE2,0,BUFFER(KQ1),LENBF2,IOS)
      IF(IOS.NE.0) RMSTAT = 2200 + IOS
  800 CONTINUE
      MODFLG(NUMBLK) = 1
      IFMOD = .TRUE.
C
C  MOVE THE TUPLE TO THE PAGE.
C
      KQ0 = BLKLOC(NUMBLK) - 1
      BUFFER(KQ0 + OFFSET) = 0
      BUFFER(KQ0 + OFFSET + 1) = LENGTH
      CALL BLKMOV(BUFFER(KQ0 + OFFSET + 2),ARRAY(1),LENGTH)
      LF2WRD = LF2WRD + LENGTH + 2
C
C  ALL DONE.
C
      RETURN
      END