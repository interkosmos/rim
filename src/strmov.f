      SUBROUTINE STRMOV(FTXT,FPOS,NUMC,TTXT,TPOS)
      INCLUDE 'syspar.d'
C
C
C  MOVE NUMC ASCII-CHARS FROM FTXT(FPOS) -> TTXT(TPOS)               .
C
      IF (NUMC.EQ.0) RETURN
      DO 100 I = 1, NUMC
      CALL GETT(FTXT,FPOS+I-1,A)
      CALL PUTT(TTXT,TPOS+I-1,A)
100   CONTINUE
      RETURN
      END
