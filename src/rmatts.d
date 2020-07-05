C  ATTRIBUTE TYPES
C
C
C     MATVEC TYPES
C
C       KZSCA  - SCALER
C       KZVEC  - VECTOR
C       KZMAT  - MATRIX
C
      PARAMETER (KZSCA=0, KZVEC=1, KZMAT=2)
C
C
C     SCALER ATTRIBUTES (VECTOR TYPE = KZSCA)
C
C       KZINT -- INTEGER
C       KZREAL - REAL
C       KZDOUB - DOUBLE PRECISION
C       KZTEXT - TEXT
C       KZDATE - DATE
C       KZTIME - TIME
C       KZPROC - PROCEDURE  (USED ONLY IN REPORT WRITER )
C
      PARAMETER (KZINT=1, KZREAL=2, KZDOUB=3, KZTEXT=4)
      PARAMETER (KZDATE=5, KZTIME=6)
      PARAMETER (KZPROC=9)
C
C     VECTOR ATTRIBUTES (VECTOR TYPE = KZVEC)
C
C       KZIVEC - INTEGER VECTOR
C       KZRVEC - REAL VECTOR
C       KZDVEC - DOUBLE PRECISION VECTOR
C
      PARAMETER (KZIVEC=KZVEC*ZHALF+KZINT)
      PARAMETER (KZRVEC=KZVEC*ZHALF+KZREAL)
      PARAMETER (KZDVEC=KZVEC*ZHALF+KZDOUB)
C
C     MATRIX ATTRIBUTES (VECTOR TYPE = KZMAT)
C
C       KZIMAT - INTEGER MATRIX
C       KZRMAT - REAL MATRIX
C       KZDMAT - DOUBLE PRECISION MATRIX
C
      PARAMETER (KZIMAT=KZMAT*ZHALF+KZINT)
      PARAMETER (KZRMAT=KZMAT*ZHALF+KZREAL)
      PARAMETER (KZDMAT=KZMAT*ZHALF+KZDOUB)
C
C
C       RMTYPT RETURNS THE CHARACTER REPRESENTATION
C       OF A TYPE CODE
C
      CHARACTER*4 RMTYPT
