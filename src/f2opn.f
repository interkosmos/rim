      SUBROUTINE F2OPN(RIMDB2)
      INCLUDE 'syspar.d'
C
C  PURPOSE:    OPEN A DATA RANDOM IO PAGING FILE - FILE 2
C
C  PARAMETERS:
C        RIMDB2-----NAME OF THE FILE TO USE FOR FILE 2
C
      INCLUDE 'ascpar.d'
      INCLUDE 'f2com.d'
      INCLUDE 'flags.d'
      INCLUDE 'buffer.d'
      INCLUDE 'rimcom.d'
 
      LOGICAL NE
      CHARACTER*(ZFNAML) RIMDB2
C
C  OPEN UP THE PAGED DATA FILE.
C
      CALL RIOOPN(RIMDB2,FILE2,LENBF2,IOS)
C
C---  CALL MSG(' ','F2OPN: ' // RIMDB2,'+')
C---  CALL IMSG(FILE2,3,'+')
C---  CALL IMSG(IOS,5,' ')
      IF(IOS.NE.0) RMSTAT = 2200 + IOS
C
C  SEE IF THE FILE EXISTS YET. IF SO, READ CONTROL DATA.
C
      CALL BLKDEF(1,LENBF2,1)
      KQ1 = BLKLOC(1)
      KQ0 = KQ1 - 1
      CALL RIOIN(FILE2,1,BUFFER(KQ1),LENBF2,IOS)
      IF(IOS.NE.0) GO TO 100
      IF(NE(KDBHDR,BUFFER(KQ0 + ZFXHID))) GO TO 8000
      IF(NE(OWNER,BUFFER(KQ0 + ZFXHOW))) GO TO 8000
CC    IF(DBDATE.NE.BUFFER(KQ0 + ZFXHDT)) GO TO 8000
CC    IF(DBTIME.NE.BUFFER(KQ0 + ZFXHTM)) GO TO 8000
      GO TO 10
C
C  CONTROL VALUES DO NOT MATCH.
C
 8000 CONTINUE
      RMSTAT = 12
   10 CONTINUE
      LF2REC = BUFFER(KQ0 + ZF2HLR)
      LF2WRD = BUFFER(KQ0 + ZF2HNW)
      GO TO 200
C
C  INITIALIZE THE CONTROL VARIABLES.
C
  100 CONTINUE
      LF2REC = 1
      LF2WRD = 20
C
C  WRITE OUT THE CONTROL BLOCK FOR THE FIRST TIME.
C
      CALL ZEROIT(BUFFER(KQ1),LENBF2)
      CALL ZMOVE(BUFFER(KQ0 + ZFXHDB),DBNAME)
      CALL ZMOVE(BUFFER(KQ0 + ZFXHID),KDBHDR)
      CALL ZMOVE(BUFFER(KQ0 + ZFXHOW),OWNER )
      BUFFER(KQ0 + ZFXHDT) = DBDATE
      BUFFER(KQ0 + ZFXHTM) = DBTIME
      BUFFER(KQ0 + ZF2HLR) = LF2REC
      BUFFER(KQ0 + ZF2HNW) = LF2WRD
      CALL RIOOUT(FILE2,0,BUFFER(KQ1),LENBF2,IOS)
      IF(IOS.NE.0) RMSTAT = 2200 + IOS
  200 CONTINUE
C
C  INITIALIZE THE CONTROL BLOCKS.
C
      CURBLK(1) = 1
      CURBLK(2) = 0
      CURBLK(3) = 0
      CALL ZEROIT(MODFLG,3)
      RETURN
      END
