      SUBROUTINE TIOIN(FILE,TEXT,LEN,EOF)
      INCLUDE 'syspar.d'
C
C     **UNIX SYSTEM DEPENDENT ROUTINE **
C
C  ROUTINE TO READ A RECORD OF ASCII-TEXT
C
C  PARAMETERS
C
C         FILE----UNIT TO READ
C         TEXT----INPUT RECORD (PACKED ASCII-TEXT)
C         LEN-----NUMBER OF CHARACTERS IN TEXT
C         EOF-----END-OF-FILE FLAG (0=NO, 1=YES)
C
      INTEGER TEXT(1)
C
      INCLUDE '../src/flags.d' 
      INCLUDE '../src/prom.d'
C
      CHARACTER*(ZCARDL) INCARD
      INTEGER ASCCHR
C
C  READ A CARD FROM THE CURRENT FILE.
C
      READ(FILE,'(A)',END=900) INCARD
      INLINE = INLINE + 1   
C
C  CONVERT INPUT TO ASCII-TEXT
C
      LEN = 0
      DO 200 I = 1,ZCARDL
      CALL PUTT(TEXT,I,ASCCHR(INCARD(I:I)))
200   IF (INCARD(I:I).NE.' ') LEN = I
      EOF = 0
      RETURN
C
C  END OF RECORD ENCOUNTERED.
C
 900  CONTINUE
      EOF = 1
C5/15/89  REWIND FILE
c     IF (PRMPT) THEN
c        MSUNIT = NOUT
c        CALL AMSG(PROM,-ZC,' ')
c     ENDIF
      RETURN
      END
