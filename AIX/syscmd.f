      SUBROUTINE SYSCMD(CMD,ERR)
      INCLUDE 'syspar.d'
C
C     ***UNIX SYSTEM DEPENDENT ROUTINE ***
C
C     EXECUTE A SYSTEM (UNIX SHELL) COMMAND
C
      CHARACTER*(*) CMD
C
      ERR = SYSTEM(CMD)
C
      RETURN
      END
