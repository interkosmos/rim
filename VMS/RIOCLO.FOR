      SUBROUTINE RIOCLO(FILE)
      INCLUDE 'TEXT.DCK'
      INCLUDE 'SYSPAR.DCK'
C
C     *** VAX SYSDEP ROUTINE
C
C     CLOSE A RANDOM ACCESS FILE
C
      close(file)       
      RETURN
      END
