C
C  *** / T U P L E R / ***
C
C  ONE TUPLE OF THE RELTBL RELATION
C
      COMMON /TUPLER/ NAME(Z),RDATE,RPW(Z),MPW(Z),NCOL,NATT,
     1  NTUPLE,RSTART,REND
      PARAMETER (ZTUPAR=3*Z+6)
C
C  VARIABLE DEFINITIONS:
C         NAME----RELATION NAME
C         RDATE---DATE OF LAST MODIFICATION TO RELATION
C         NCOL----NUMBER OF COLUMNS OF FIXED LENGTH
C         NATT----NUMBER OF ATTRIBUTES
C         NTUPLE--NUMBER OF DEFINED TUPLES
C         RSTART--DATA FILE POINTER FOR THE START OF THE RELATION
C         REND----DATA FILE POINTER FOR THE END OF THE RELATION
C         RPW-----READ PASSWORD
C         MPW-----MODIFY PASSWORD
C