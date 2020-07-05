C
C  *** / R I M C O M / ***
C
C  RIM FORTRAN INTERFACE STATUS COMMON
C
      COMMON /RIMCOM/ RMSTAT
      INTEGER RMSTAT
C
C  VARIABLE DEFINITIONS
C     RMSTAT--STATUS FLAG
C               -1  NO MORE DATA AVAIABLE FOR RETRIEVAL
C                0  OK - OPERATION SUCCESSFULL
C               10  DATABASE FILES DO NOT CONTAIN A RIM DATABASE
C               11  DATABASE NAME DOES NOT MATCH FILE CONTENTS
C               12  INCOMPATABLE DATABASE FILES (DATE,TIME,ETC)
C               13  DATABASE IS ATTACHED IN READ ONLY MODE
C               14  DATABASE IS BEING UPDATED
C               15  DATABASE FILES ARE NOT LOCAL FILES
C               20  UNDEFINED RELATION
C               30  UNDEFINED ATTRIBUTE
C               40  MORE THAN 10 AND/OR OPERATORS IN THE WHERE CLAUSE
C               41  ILLEGAL "LIMIT EQ N" CONDITION
C               42  UNRECOGNIZED BOOLEAN COMPARISON
C               43  EQS ONLY AVAILABLE FOR TEXT ATTRIBUTES
C               44  ILLEGAL USE OF MIN/MAX IN THE WHERE CLAUSE
C               45  UNRECOGNIZED AND/OR OPERATOR
C               46  COMPARED ATTRIBUTES MUST BE THE SAME TYPE/LENGTH
C               47  LISTS ARE VALID ONLY FOR EQ NE AND CONTAINS
C               48  ILLEGAL ROW SPECIFICATION
C               50  RMFIND NOT CALLED
C               60  RMGET NOT CALLED
C               70  RELATION REFERENCE NUMBER OUT OF RANGE
C               80  VARIABLE LENGTH ATTRIBUTES MAY NOT BE SORTED
C               81  THE NUMBER OF SORTED ATTRIBUTES IS TOO LARGE
C               89  SORT SYSTEM ERROR (SHOULD NEVER GET THIS)
C               90  UNAUTHORIZED RELATION ACCESS
C              100  ILLEGAL VARIABLE LENGTH TUPLE DEFINITION (LOAD/PUT)
C              110  UNRECOGNIZED RULE RELATIONS
C              111  MORE THAN 10 RULES PER RELATION
C              112  UNABLE TO PROCESS RULES
C              2XX  TUPLE VIOLATES RULE XX
C
C         THE FOLLOWING CODES SHOULD NOT BE ENCOUNTERED IN NORMAL USE
C
C             1001  BUFFER SIZE PROBLEM - BLKCHG,BLKDEF
C             1002  UNDEFINED BLOCK - BLKLOC
C             1003  CANNOT FIND A LARGER BTREE VALUE - BTADD,PUTDAT
C             1004  CANNOT FIND BTREE BLOCK - BTPUT
C
C             21XX  RANDOM FILE ERROR XX ON FILE1
C             22XX  RANDOM FILE ERROR XX ON FILE2
C             23XX  RANDOM FILE ERROR XX ON FILE3
C             24XX  RANDOM FILE ERROR XX ON FILE4
C
