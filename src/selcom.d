C
C   *** / S E L C O M / ***
C
C
      COMMON /SELCOM/ NUMATT, COL1(ZMSEL),ITEMW(ZMSEL),
     X  CURPOS(ZMSEL),NUMCOL(ZMSEL),
     X  FORMT(ZMSEL),ATYPE(ZMSEL),LEN(ZMSEL),
     X  ROWD(ZMSEL),COLD(ZMSEL),FP(ZMSEL),
     X  SINGLE(ZMSEL),VAR(ZMSEL),
     X  SUMFLG(ZMSEL),LIN1(ZMSEL),
     X  SFUNCT, FUNCT(ZMSEL), SGRPBY,
     X  SLNKFL, LNKFL(ZMSEL), SLVMHD,
     X  TITLE(ZPRINW),MINUS(ZPRINW),LINE(ZPRINW), SLNKNM(Z,ZMSLK)
      PARAMETER (ZSELCM=1+12*ZMSEL)
      LOGICAL VAR
      LOGICAL SUMFLG
      LOGICAL SFUNCT
      LOGICAL SLVMHD
C
C  VARIABLE DEFINITIONS:
C     NUMATT....NUMBER OF ATTRIBUTES
C     COL1......FIRST COLUMN IN LINE TO PRINT INTO
C     ITEMW.....NUMBER OF COLUMNS PER ITEM
C     CURPOS....CURRENT POSITION IN ATTRIBUTE (FOR PARAGRAPHING)
C     NUMCOL....NUMBER OF COLUMNS AVAILABLE FOR THIS ATTRIBUTE
C     PFORMT....FORMAT INPUT BY USER OR ZERO
C     TRUNC.....TRUE IFF ROWS ARE TO BE TRUNCATED  AS PARAGRAPHS
C     ATYPE.....ATTRIBUTE TYPE
C     LEN.......ATTRIBUTE LENGTH (WORDS EXCEPT TEXT IS CHARACTERS)
C     ROWD......ROW DIMENSION
C     COLD......COLUMN DIMENSION
C     VAR.......TRUE IFF VARIABLE ATTRIBUTE
C     FP........POINTER TO CELL IF FIXED POTION OF TUPLE
C     SINGLE....CONTAINS ROW/COL OR ENTRY FOR MAT(I,J)/VEC(J) ITEMS
C     SLVMHD....TRUE IF SHOULD PRINT VAR VEC AND MAT HEADERS
C     LINE......OUTPUT LINE SPACE (ASCII-TEXT)
C     TITLE.....TITLE LINE
C     MINUS.....LINE WITH DASHES
C     SLNKFL....NUMBER OF INDEPENDENT LINKS
C     LNKFL.....0=NO LINK, ELSE INDEX INTO LNKNAM
C     SLNKNM....LINK NAMES
C
C     ZSELC1....LENGTH OF COMMON THROUGH SUMFLG (FOR PROGRAM MODE)