      SUBROUTINE SYSEXI

      IMPLICIT INTEGER (A-Z)
C
C     RESET INPUT ERROR 212 COUNTER (SHORT RECORD ERRORS)
C             AND ERROR 219 COUNTER (NO FILE ERRORS)
C
      INTEGER TAB(2)

      CALL ERRSAV(212,TAB)
      TAB(1) = 0
      CALL ERRSTR(212,TAB)

      CALL ERRSAV(219,TAB)
      TAB(1) = 0
      CALL ERRSTR(219,TAB)

      CALL ERRSAV(218,TAB)
      TAB(1) = 0
      CALL ERRSTR(218,TAB)

      CALL ERRSAV(171,TAB)
      TAB(1) = 0
      CALL ERRSTR(171,TAB)

      RETURN
      END