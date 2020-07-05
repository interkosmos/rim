      SUBROUTINE DBLOAD(*)
      INCLUDE 'syspar.d'
C
C  THIS ROUTINE IS THE DRIVER FOR LOADING DATA VALUES IN THE
C  RIM DATA BASE.
C
C     :  LOAD REL_NAME <FROM FILE_NAME> <USING FILENAME>
 
      INCLUDE 'ascpar.d'
      INCLUDE 'tokens.d'
      INCLUDE 'tuplea.d'
      INCLUDE 'tupler.d'
      INCLUDE 'files.d'
      INCLUDE 'buffer.d'
      INCLUDE 'flags.d'
      INCLUDE 'rimcom.d'
      INCLUDE 'prom.d'
C
      LOGICAL EQKEYW
      INCLUDE 'dclar1.d'
      CHARACTER*(ZFNAML) FN, DFN
C
C     PARSING DATA FOR QUERY COMMANDS
C
      PARAMETER (QKEYL=2)
      CHARACTER*(ZKEYWL) QKEYS(QKEYL)
      INTEGER QPTRS(2,QKEYL)
C
C
C     CHECK FOR A DATABASE
C
      IF (.NOT.DFLAG) THEN
         CALL WARN(2,0,0)
         GOTO 999
      ENDIF
C
C  MAKE SURE THE DATABASE CAN BE MODIFIED
C
      IF (.NOT.DMFLAG) THEN
         CALL WARN(8,0,0)
         GO TO 999
      ENDIF
C
      QKEYS(1) = 'FROM'
      QKEYS(2) = 'USING'
C
C  PARSE THE COMMAND
C
      SC = PARSE(QKEYS,QKEYL,QPTRS)
      JI = QPTRS(1,1)
      JU = QPTRS(1,2)
      IF ( (JI.NE.0 .AND. QPTRS(2,1).NE.2) .OR.
     1     (JU.NE.0 .AND. QPTRS(2,2).NE.2)) THEN
         CALL WARN(4,0,0)
         GOTO 999
      ENDIF
C
C  LOOK FOR THE RELATION NAME
C
      CALL LXSREC(2,RNAME,ZC)
      I = LOCREL(RNAME)
      IF(I.NE.0) GOTO 850
      CALL RELGET(ISTAT)
      IF(ISTAT.NE.0) GO TO 850
C
C  CHECK FOR AUTHORITY.
C
      L = LOCPRM(RNAME,2)
      IF(L.NE.0) THEN
         CALL WARN(9,RNAME,0)
         GO TO 999
      ENDIF
C
C     IF PROG INTERFACE THEN RETURN NOW
C
      IF (PIFLAG) THEN
         CALL RMPII
         GOTO 999
      ENDIF
C
C     CHECK IF INPUT FROM FILE
C
      IF (JI.NE.0) THEN
         CALL STRASC(DFN,ASCREC(IDP(JI+1)),IDL(JI+1))
         IF (KWS(JI+1).EQ.'TERMINAL') JI = 0
      ENDIF
      IF (JU.NE.0 .AND. JI.EQ.0) THEN
         CALL MSG('E','FORMATTED LOADING REQUIRES A DATA FILE.',' ')
         GOTO 999
      ENDIF
 
C
C     CHECK IF FORMATTED
C
97    IF (JU.NE.0) THEN
C        GET THE FILE WITH THE FORMAT
         CALL STRASC(FN,ASCREC(IDP(JU+1)),IDL(JU+1))
         IF (KWS(JU+1).EQ.'TERMINAL') FN = ZTRMIN
98       CALL SETIN(FN)
C
C        ALLOCATE A BLOCK FOR THE FORMAT
C            1) ATTCOL
C            2) LINE NUMBER
C            3) STARTING COLUMN NUMBER
C            4) FIELD LENGTH PER ITEM (FROM FORMAT SPEC)
C            5) FORMAT
C            6) ITEM POSITION (LOADFM CALCULATES THIS)
C
C        LOOK FOR FORMAT CARD
99       CALL LODREC
         IF (.NOT.EQKEYW(1,'FORMAT')) THEN
            CALL MSG('E','A ''FORMAT'' BLOCK WAS EXPECTED ON ''' //
     1           FN // '''',' ')
            GOTO 999
         ENDIF
         CALL BLKDEF(9,6,NATT+1)
         FOR = BLKLOC(9)
 
C        LOAD FORMAT SPECIFICATIONS
         FPTR = FOR - 1
100      CALL LODREC
         IF (EQKEYW(1,'END')) GOTO 200
 
C        LINE IS:  LINE#, COLUMN#, ATTRIBUTE, FORMAT
 
C        POSITION  (ITEMS 1 & 2)
         IF (IDI(1).LE.0 .OR. IDI(2).LE.0) THEN
            CALL MSG('E','POSITIONS MUST BE POSITIVE INTEGERS.',' ')
            GOTO 999
         ENDIF
         BUFFER(2+FPTR) = IDI(1)
         BUFFER(3+FPTR) = IDI(2)
 
C        ATTRIBUTE (ITEM 3)
         IF (TOKTYP(3,KXNAME)) THEN
            CALL LXSREC(3,ANAME,ZC)
            IF (LOCATT(ANAME,NAME).NE.0) THEN
               CALL WARN(3,ANAME,NAME)
               GOTO 999
            ENDIF
            CALL ATTGET(STATUS)
            BUFFER(1+FPTR) = ATTCOL
         ELSE
            BUFFER(1+FPTR) = 0
         ENDIF
 
C        FORMAT
         CALL TYPER(ATTYPE,SVM,TYP)
         CALL LXFMT(4,TYP,FMT,FMTLEN)
         IF (FMT.EQ.0) GOTO 999
         BUFFER(4+FPTR) = FMTLEN
         BUFFER(5+FPTR) = FMT
         BUFFER(6+FPTR) = 0
 
         FPTR = FPTR + 6
         GOTO 100
 
200      NFOR = (FPTR - FOR + 1) / 6
         IF (NFOR.LE.0) THEN
            CALL MSG('E','YOU HAVE NOT SPECIFIED ANY FORMATS.',' ')
            GOTO 999
         ENDIF
      ENDIF
C
C     IF INPUT FROM FILE  -  OPEN NOW
C
      IF (JI.NE.0 .AND. DFN.NE.FN) CALL SETIN(DFN)
C
C  SET THE PROMPT CHARACTER TO L (LOAD)
C
      CALL PRMSET('SET','RIM_LOAD:')
C
      CALL MSG(' ','LOADING TABLE ''','+')
      CALL AMSG(NAME,-ZC,'+')
      CALL MSG(' ','''',' ')
C
C  DO THE LOADING
C
      CALL BLKDEF(11,ZTUPAL,NATT)
C
C  FILL UP THIS MATRIX WITH DATA FROM TUPLEA.
C
      I = LOCATT(BLANK,NAME)
      KQ2 = BLKLOC(11)
      DO 800 I=1,NATT
      CALL ATTGET(ISTAT)
      IF(ISTAT.NE.0) GO TO 800
      CALL BLKMOV(BUFFER(KQ2),ATTNAM,ZTUPAL)
      KQ2 = KQ2 + ZTUPAL
  800 CONTINUE
      CALL BLKDEF(10,1,MAXCOL)
      KQ1 = BLKLOC(10)
      KQ2 = BLKLOC(11)
899   IF (JU.NE.0) THEN
        CALL LOADFM(BUFFER(KQ1),BUFFER(KQ2),BUFFER(FOR),NFOR)
        CALL BLKCLR(9)
      ELSE
        CALL LOADIT(BUFFER(KQ1),BUFFER(KQ2))
      ENDIF
      CALL BLKCLR(11)
C
C  UPDATE THE DATE OF LAST MODIFICATION.
C
      CALL RMDATE(RDATE)
      CALL RELPUT
      CALL BLKCLR(10)
C
C     MAY BE A SECOND LOAD COMMAND
C
CCCCC IF(EQKEYW(1,'LOAD')) GO TO 400
C
C  END OF LOADING.
C
      CALL MSG(' ','END DATA LOADING',' ')
C
C  RESET THE PROMPT CHARACTER
C
      CALL PRMSET('RESET',' ')
      GOTO 999
C
C     UNRECOGNIZED RELATION NAME.
850   CALL WARN(1,RNAME,0)
C
999   RETURN 1
      END
