      FUNCTION LSTRNG(S1,I1,N1,S2,I2,N2)
      INCLUDE 'syspar.d'
C
C        SCANS FOR A CHARACTER STRING IN  S1 THAT MATCHES THE
C        CHARACTER STRING  S2
C     (BOTH STRINGS ARE ASCII-TEXT)
C
C        S1 - STRING TO SEARCH
C        I1 - FIRST CHAR OF S1 TO CHECK
C        N1 - NUMBER OF CHARACTERS IN S1 TO CHECK
C        S2 - STRING TO MATCH
C        I2 - FIRST CHAR OF S2 TO MATCH
C        N2 - NUMBER OF CHARACTERS IN S2 TO MATCH
C
C        LSTRNG = CHARACTER POS OF STRING MATCH
C        LSTRNG = 0 IF THE STRING WAS NOT FOUND
C
      INCLUDE 'flags.d'
C
C     THE ARBITRARY CHAR (ARBCHS) MATCHES ANY CHARACTER
C     CASE IGNORE (CASEIG) MATCHES UPPER AND LOWER CASE
C
      IF (N1.LT.N2) GOTO 999
C
      CALL GETT(S2,I2,A21)
      DO 200 I = I1, I1 + N1 - N2
      IF (A21.NE.ARBCHS) THEN
         CALL GETT(S1,I,A1)
         IF (CASEIG) THEN
            A1 = UPCASE(A1)
            A21 = UPCASE(A21)
         ENDIF
         IF (A1.NE.A21) GOTO 200
      ENDIF
C     FIRST CHAR MATCH FOUND
      DO 100 J = 1, N2 - 1
      CALL GETT(S2,I2+J,A2X)
      IF (A2X.NE.ARBCHS) THEN
         CALL GETT(S1,I+J,A1X)
         IF (CASEIG) THEN
            A1X = UPCASE(A1X)
            A2X = UPCASE(A2X)
         ENDIF
         IF (A1X.NE.A2X) GOTO 200
      ENDIF
100   CONTINUE
C     FOUND
      LSTRNG = I
      RETURN
200   CONTINUE
C     NOT FOUND
999   LSTRNG = 0
      RETURN
      END