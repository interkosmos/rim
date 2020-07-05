      SUBROUTINE JOIREL(*)
 
      INCLUDE 'syspar.d'
C
C  THIS ROUTINE FINDS THE JOIN OF TWO RELATIONS BASED UPON JOINING
C  TWO ATTRIBUTES.  THE RESULT FROM THIS PROCESS IS A
C  RELATION WHICH HAS TUPLES CONTRUCTED FROM BOTH RELATIONS
C  WHERE THE SPECIFIED ATTRIBUTES MATCH AS REQUESTED.
C
C  THE SYNTAX FOR THE JOIN COMMAND IS:
C
C  JOIN REL1 USING ATT1 WITH REL2 USING ATT2 FORMING REL3 WHERE EQ
C
      INCLUDE 'ascpar.d'
      INCLUDE 'tokens.d'
      INCLUDE 'rmatts.d'
      INCLUDE 'flags.d'
      INCLUDE 'rimcom.d'
      INCLUDE 'tupler.d'
      INCLUDE 'tuplea.d'
      INCLUDE 'files.d'
      INCLUDE 'buffer.d'
      INCLUDE 'whcom.d'
C
      INTEGER PTABLE
      LOGICAL EQ
      LOGICAL NE
      LOGICAL EQKEYW
      INCLUDE 'dclar1.d'
      INCLUDE 'dclar3.d'
C  LOCAL ARRAYS AND VARIABLES :
C
      INCLUDE 'ptbl.d'
C        PTABLE (MATRIX 7) USED TO CONTROL POINTERS
C        PTBL1-- ATTRIBUTE NAME
C        PTBL2-- ATTRIBUTE LOCATION IN RELATION 1
C        PTBL3-- ATTRIBUTE LOCATION IN RELATION 2
C        PTBL4-- ATTRIBUTE LOCATION IN RELATION 3
C        PTBL5-- LENGTH IN WORDS
C        PTBL6-- ATTRIBUTE TYPE
C
C
C     CHECK FOR A DATABASE
C
      IF (.NOT.DFLAG) THEN
         CALL WARN(2,0,0)
         GOTO 999
      ENDIF
C
C
C     MAKE SURE THE DATABASE MAY BE MODIFIED
C
      IF(.NOT.DMFLAG) THEN
        CALL WARN(8,0,0)
        GO TO 999
      ENDIF
C
C  EDIT COMMAND SYNTAX
C
      CALL BLKCLN
      IF(.NOT.EQKEYW(3,'USING'))   GO TO 900
      IF(.NOT.EQKEYW(5,'WITH'))    GO TO 900
      IF(.NOT.EQKEYW(7,'USING'))   GO TO 900
      IF(.NOT.EQKEYW(9,'FORMING')) GO TO 900
C
C  SET DEFAULT WHERE CONDITION (EQ OR NK = 2)
C
      NK = 2
      IF(ITEMS.LE.10) GO TO 50
C
C  CHECK WHERE COMPARISON.
C
      IF(.NOT.EQKEYW(11,'WHERE')) GO TO 900
      NK = LOCBOO(KWS(12))
      IF(NK.EQ.0) GO TO 900
      IF(NK.EQ.1) GO TO 900
C
C  KEYWORD SYNTAX OKAY
C
50    CALL LXSREC(2,RNAME1,ZC)
      I = LOCREL(RNAME1)
      IF(I.NE.0) THEN
C       MISSING FIRST RELATION.
        CALL WARN(1,RNAME1,0)
        GO TO 999
      ENDIF
C
C  SAVE DATA ABOUT RELATION 1
C
      I1 = LOCPRM(RNAME1,1)
      IF(I1.NE.0) THEN
        CALL WARN(9,RNAME1,0)
        GO TO 999
      ENDIF
      NCOL1 = NCOL
111   NATT1 = NATT
      CALL ZMOVE(RPW1,RPW)
      CALL ZMOVE(MPW1,MPW)
C
C  CHECK THE COMPARISON ATTRIBUTE.
C
      CALL LXSREC(4,ANAME1,ZC)
      I = LOCATT(ANAME1,RNAME1)
      IF(I.NE.0) THEN
        CALL WARN(3,ANAME1,RNAME1)
        GO TO 999
      ENDIF
C
C     CHECK SECOND RELATION
C
      CALL LXSREC(6,RNAME2,ZC)
      I = LOCREL(RNAME2)
      IF(I.NE.0) THEN
C       MISSING SECOND RELATION.
        CALL WARN(1,RNAME2,0)
        GO TO 999
      ENDIF
C
C  SAVE DATA ABOUT RELATION 2
C
      I2 = LOCPRM(RNAME2,1)
      IF(I2.NE.0) THEN
        CALL WARN(9,RNAME2,0)
        GO TO 999
      ENDIF
      NCOL2 = NCOL
      NATT2 = NATT
      CALL ZMOVE(RPW2,RPW)
      CALL ZMOVE(MPW2,MPW)
C
C  CHECK THE COMPARISON ATTRIBUTE.
C
      CALL LXSREC(8,ANAME2,ZC)
      I = LOCATT(ANAME2,RNAME2)
      IF(I.NE.0) THEN
        CALL WARN(3,ANAME2,RNAME2)
        GO TO 999
      ENDIF
C
C  CHECK FOR LEGAL RNAME3
C
      IF(.NOT.TOKTYP(10,KXNAME)) THEN
        CALL WARN(7,ASCREC(IDP(10)),0)
        GO TO 999
      ENDIF
C
C  CHECK FOR DUPLICATE RELATION 3
C
      CALL LXSREC(10,RNAME3,ZC)
      I = LOCREL(RNAME3)
      IF(I.EQ.0) THEN
        CALL WARN(5,RNAME3,0)
        GO TO 999
      ENDIF
C
C  CHECK USER READ SECURITY
C
      IF((I1.NE.0).OR.(I2.NE.0)) GO TO 999
C
C  RELATION NAMES OKAY -- CHECK THE ATTRIBUTES
C
C  SET UP PTABLE IN BLOCK 7
C
      CALL BLKDEF(7,PTBLL,NATT1+NATT2)
      PTABLE = BLKLOC(7)
      NATT3 = 0
      ICT = 1
C
C  STORE DATA FROM RELATION 1 IN PTABLE
C
      I = LOCATT(BLANK,RNAME1)
      DO 500 I=1,NATT1
      CALL ATTGET(ISTAT)
      IF(ISTAT.NE.0) GO TO 500
      NATT3 = NATT3 + 1
      CALL ZMOVE(BUFFER(PTABLE),ATTNAM)
      BUFFER(PTABLE+PTBL2-1) = ATTCOL
      BUFFER(PTABLE+PTBL4-1) = ICT
      NWORDS = ATTWDS
      BUFFER(PTABLE+PTBL5-1) = ATTLEN
      IF(NWORDS.EQ.0) NWORDS = 1
      ICT = ICT + NWORDS
      BUFFER(PTABLE+PTBL6-1) = ATTYPE
      BUFFER(PTABLE+PTBL7-1) = ATTFOR
      PTABLE = PTABLE + PTBLL
500   CONTINUE
C
C  STORE DATA FROM RELATION 2 IN PTABLE
C
      KATT3 = NATT3
      I = LOCATT(BLANK,RNAME2)
      DO 550 I=1,NATT2
      CALL ATTGET(ISTAT)
      IF(ISTAT.NE.0) GO TO 550
C
C  FIRST CHECK TO SEE IF ATTRIBUTE IS ALREADY IN PTABLE.
C
      KQ1 = BLKLOC(7) - PTBLL
      DO 520 J=1,KATT3
      KQ1 = KQ1 + PTBLL
      IF(BUFFER(KQ1+PTBL3-1).NE.0) GO TO 520
      IF (EQ(BUFFER(KQ1),ATTNAM)) THEN
         CALL MSG('W','COLUMN ''','+')
         CALL AMSG(ATTNAM,-ZC,'+')
         CALL MSG(' ',''' IS DUPLICATED.  ','+')
         CALL MSG(' F','YOU SHOULD RENAME IT.',' ')
         GO TO 530
      ENDIF
520   CONTINUE
C
C  ADD THE DATA TO PTABLE.
C
530   NATT3 = NATT3 + 1
      CALL ZMOVE(BUFFER(PTABLE),ATTNAM)
      BUFFER(PTABLE+PTBL3-1) = ATTCOL
      BUFFER(PTABLE+PTBL4-1) = ICT
      NWORDS = ATTWDS
      BUFFER(PTABLE+PTBL5-1) = ATTLEN
      IF(NWORDS.EQ.0) NWORDS = 1
      ICT = ICT + NWORDS
      BUFFER(PTABLE+PTBL6-1) = ATTYPE
      BUFFER(PTABLE+PTBL7-1) = ATTFOR
      PTABLE = PTABLE + PTBLL
550   CONTINUE
      ICT = ICT - 1
C
C  PTABLE IS CONSTRUCTED
C
C  NOW CREATE ATTRIBUTE AND RELATION TABLES AND THE RELATION
C
      IF(ICT.GT.MAXCOL) GO TO 930
C
C  SET UP THE WHERE CLAUSE FOR THE JOIN.
C
      I = LOCATT(ANAME2,RNAME2)
      CALL ATTGET(ISTAT)
      IF(ATTWDS.GT.300) GO TO 940
      KEYCOL = ATTCOL
      KEYTYP = ATTYPE
      KEYLEN = ATTLEN
      NBOO = 1
      BOO(1) = WHAND
      I = LOCATT(ANAME1,RNAME1)
      CALL ATTGET(ISTAT)
      KATTP(1) = ATTCOL
      KATTL(1) = ATTLEN
C
C  MAKE SURE THE ATTRIBUTE TYPES MATCH.
C
      IF(KEYTYP.NE.ATTYPE) GO TO 920
      IF(KEYLEN.NE.ATTLEN) GO TO 910
      KATTY(1) = ATTYPE
      IF(KEYTYP.EQ.KZIVEC) KATTY(1) = KZINT
      IF(KEYTYP.EQ.KZRVEC) KATTY(1) = KZREAL
      IF(KEYTYP.EQ.KZDVEC) KATTY(1) = KZDOUB
      IF(KEYTYP.EQ.KZIMAT) KATTY(1) = KZINT
      IF(KEYTYP.EQ.KZRMAT) KATTY(1) = KZREAL
      IF(KEYTYP.EQ.KZDMAT) KATTY(1) = KZDOUB
      KOMTYP(1) = NK
      KOMPOS(1) = 1
      KOMLEN(1) = 1
      KOMPOT(1) = 1
      KSTRT = ATTKEY
      IF(NK.NE.2) KSTRT = 0
      MAXTU = ALL9S
      LIMTU = ALL9S
C
C  SET UP RELATION TABLE.
C
      CALL ZMOVE(NAME,RNAME3)
      CALL RMDATE(RDATE)
      NCOL = ICT
      NCOL3 = ICT
      NATT = NATT3
      NTUPLE = 0
      RSTART = 0
      REND = 0
      CALL ZMOVE(RPW,RPW1)
      CALL ZMOVE(MPW,MPW1)
      IF(EQ(RPW,NONE).AND.NE(RPW2,NONE)) CALL ZMOVE(RPW,RPW2)
      IF(EQ(MPW,NONE).AND.NE(MPW2,NONE)) CALL ZMOVE(MPW,MPW2)
      CALL RELADD
C
      CALL ATTNEW(NAME,NATT)
      PTABLE = BLKLOC(7)
      DO 700 K=1,NATT3
      CALL ZMOVE(ATTNAM,BUFFER(PTABLE))
      CALL ZMOVE(RELNAM,NAME)
      ATTCOL = BUFFER(PTABLE+PTBL4-1)
      ATTLEN = BUFFER(PTABLE+PTBL5-1)
      ATTYPE = BUFFER(PTABLE+PTBL6-1)
      ATTFOR = BUFFER(PTABLE+PTBL7-1)
      ATTKEY = 0
      CALL ATTADD
      PTABLE = PTABLE + PTBLL
  700 CONTINUE
C
C  CALL JOIN TO CONSTRUCT MATN3
C
      CALL BLKDEF(8,MAXCOL,1)
      KQ3 = BLKLOC(8)
      PTABLE = BLKLOC(7)
      I = LOCREL(RNAME2)
      CALL JOIN(RNAME1,RNAME3,BUFFER(KQ3),NCOL3,NATT3,BUFFER(PTABLE),
     XKEYCOL,KEYTYP)
      GO TO 999
C
C
C  SYNTAX ERROR IN JOIN COMMAND
C
900   CALL WARN(4,0,0)
C
C
C  MISMATCHED DATA TYPES.
C
910   CALL MSG('E','JOIN COLUMNS HAVE DIFFERENT LENGTHS.',' ')
      GO TO 999
C
920   CALL MSG('E','JOIN COLUMNS HAVE DIFFERENT TYPES.',' ')
      GO TO 999
C
930   CALL WARN(15,0,0)
      GO TO 999
C
940   CALL MSG('E','JOIN COLUMN IS TOO LONG.',' ')
      GO TO 999
C
C  DONE WITH JOIN
C
999   CALL BLKCLR(7)
      CALL BLKCLR(8)
      RETURN 1
      END