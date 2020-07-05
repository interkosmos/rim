# RIM: Relational DBMS in FORTRAN 77
RIM (*Relational Information Management*) is a relational database management
package, originally written in FORTRAN 66 for CDC Cyber, UNIVAC, DEC VAX, and
PRIME. This version of RIM is a descendent of the Boeing Computer Services
(BCS) program of the same name that was developed in 1978 as part of the IPAD
project for NASA (NAS1-14700):

> The IPAD project objective is to improve engineering productivity through
> better use of computer-aided design and manufacturing (CAD/CAM) technology. It
> focuses on development of technology and associated software for integrated
> company-wide management of engineering information.
>
> — IPAD: Integrated Programs for Aerospace-Vehicle Design (NASA Conference Publication 2143, 1980)

Despite being essentially public domain software, the package was also sold as
a commercial product (BCS RIM) for various operating systems, with interfaces
to FORTRAN, COBOL, Pascal, BASIC, and PL/I. The source code was given to the
University of Washington and further developed as UWRIM for the CDC Cyber
mainframe. UWRIM was later rewritten in FORTRAN 77 and ported to UNIX, while
the command language has been extended to be more like SQL.

The source code was last updated by Marco Valagussa and Jacques Bouchard in
1998, who added corrections and compatibility with AIX, BSD4.3, VAX/VMS, SunOS,
and Linux.

## Features
The UWRIM database management system features:

  * SQL-like querying language.
  * Multiple data types: integer, real, double (scalar, vector, matrix); text; date; time.
  * Relational table algebra (`union`, `intersect`, `substract`, `join`, `project`).
  * Password-protected databases.
  * Macros.
  * Report generation.
  * RIM-to-RIM data transfer (`unload`, `load`).
  * FORTRAN 77 interface.

## Files
RIM consists of the following files:

| File       | Description                    |
|------------|--------------------------------|
| `rim`      | The main program.              |
| `rime`     | The database editor.           |
| `rimh`     | Builds the help database.      |
| `librim.a` | The program interface library. |

Databases have the file endings `.rimdb1`, `.rimdb2`, and `.rimdb3`.

## Compilation
Use [f2c](https://www.netlib.org/f2c/) and an appropriate C compiler (`clang`,
`gcc`, …) to build RIM. The original `Makefile` has been updated to be
compatible with modern GNU make and BSD make. On FreeBSD, run:

```
$ cp LINU-DGUX/*.[cdf] src/
$ cd src/
$ make
```

On Linux, add the make argument `PREFIX=/usr`.

The compilation outputs the programs `rim`, `rime`, and `rimh`, as well as the
static library `librim.a`:

## Documentation
The “RIM Installers Manual” (`rimint.pdf`) and the “RIM Users Manual”
(`rimref.pdf`) seem to be the only documentation available. The file
`rimdoc.txt` contains the VAX/VMS user’s guide of the commercial BCS RIM-5.

## Introduction
RIM implements a relational database model that consists of a collection of one
or more *tables*. These tables (or relations) are defined with a fixed number
and sequence of columns (*attributes*) to store *tuples* of data as rows.

Databases can be accessed either from the interactive RIM program, by executing
programs written in the RIM command language, or through the FORTRAN 77
interface.

### Database Schema
The following program in the RIM command language creates a new database
schema `sample` using the `define` statement block. Then, columns are declared
with their respective data type, size, and output format. In the `tables`
section, we define the table `techs`, containing the columns `id`, `name`,
`position`, and `status`. The `define` statement is closed with `end`.

```
*(newdb.rim)
*(Creates a new RIM database schema `sample`,)
*(and loads values into table `techs`.)
echo

define sample
columns
    id          int             format i5
    name        text    var     format a12
    position    text    8
    status      text    1
tables
    techs with id name position status
end

load techs
    5  'Alice Jones'   'Tech 1' A
    22 'Carol Smith'   'Tech 2' A
    35 'Heidi Jackson' 'Tech 1' B
end

build key for name in techs

echo off
close
exit
```

Initial values are added through a `load` block. Adding a key to a column will
speed up “equals” type of searches, but slows down updates. Keys should be
added after a table is loaded.

Store the program as `newdb.rim`, and then run:

```
$ ./rim newdb.rim
UW RIM (V.1.24  08/03/90)
 define sample
Begin definitions for new database: sample
 columns
 id int format i5
 name text var format a12
 position text 8
 status text 1
 tables
 techs with id name position status
 end
Database definitions completed.
 load techs
Loading table 'techs'
 5 'Alice Jones' 'Tech 1' A
 22 'Carol Smith' 'Tech 2' A
 35 'Heidi Jackson' 'Tech 1' B
 end
End data loading
 build key for name in techs
Build key completed.
 echo off
End rim execution   06/27/**  21:55:57
```

RIM will create the database files `sample.rimdb1`, `sample.rimdb2`, and
`sample.rimdb3`.

### Data Access
Start the interactive RIM interpreter and open the database `sample`:

```
$ ./rim
UW RIM (V.1.24  08/03/90)
Rim: open 'sample'
Database 'sample' is open.
```

We can list all tables of the database with `list`:

```
Rim: list
 list
  Table name         rows  last modified
  ---------------- ------  ------------
  techs                 3  06/27/**
```

The `select` query returns the rows:

```
Rim: select * from techs
 select * from techs
 Table: techs
 id     name          position   status
 -----  ------------  ---------  -------
     5  Alice Jones   Tech 1     A
    22  Carol Smith   Tech 2     A
    35  Heidi         Tech 1     B
        Jackson
         3 rows selected.
```

For sorted output, add the `sort` clause to the `select` query:

```
Rim: select * from techs sort by position
 Table: techs
 id     name          position   status
 -----  ------------  ---------  -------
     5  Alice Jones   Tech 1     A
    35  Heidi         Tech 1     B
        Jackson
    22  Carol Smith   Tech 2     A
         3 rows selected.
```

Furthermore, specific rows can be selected adding a `where` clause:

```
Rim: select name%'Tech Name' from techs where id < 30
 Table: techs
 Tech Name
 ------------
 Alice Jones
 Carol Smith
         2 rows selected.
```

The label of the column is given with the `%` operator. The `delete` command
removes rows from a table:

```
Rim: delete rows from techs where id = 5
        1 rows were deleted.
```

We can close the database with `close` and quit the RIM program with `exit`.

## FORTRAN 77
The example program `example.f` uses the database schema `sample` that was
declared above:

```
C     *****************************************************************
C     FORTRAN 77 EXAMPLE PROGRAM FOR RIM DATABASE ACCESS.
C     *****************************************************************
      PROGRAM MAIN
      EXTERNAL ERROR
      EXTERNAL STRASC
      LOGICAL  RIM, RIMDM
      CHARACTER*16 STRING
      INTEGER      TUPLE(32)
      INTEGER      RMSTAT
      COMMON /RIMCOM/ RMSTAT

      PRINT *, 'FORTRAN 77 INTERFACE TO RIM'
      PRINT *, '***************************'

      IF (RMSTAT .NE. 0) CALL ERROR(RMSTAT)
      IF (.NOT. RIM(1, 'open sample')) CALL ERROR(RMSTAT)
      IF (.NOT. RIM(1, 'select from techs sort by name'))
     &  CALL ERROR(RMSTAT)

      PRINT *, 'Names:'
   10 IF (RIMDM(1, 'GET', TUPLE)) THEN
        CALL STRASC(STRING, TUPLE(8), 16)
        PRINT *, STRING
        GOTO 10
      END IF
      END
C     *****************************************************************
      SUBROUTINE ERROR(RMSTAT)
      INTEGER RMSTAT
      PRINT 100, 'ERROR: ', RMSTAT
  100 FORMAT (A, I1)
      STOP
      END
C     *****************************************************************
```

Compile the example program with:

```
$ f2c example.f
$ cc -I/usr/local/include/ -L/usr/local/lib/ \
  -o example example.c librim.a /usr/local/lib/libf2c.a -lm -lf2c
```

Then, simply run:

```
$ ./example
 FORTRAN 77 INTERFACE TO RIM
 ***************************
 Names:
 Alice Jones
 Carol Smith
 Heidi Jackson
```

## References

  * Biser, A. O.: A Method for Data Base Management and Analysis for Wind-Tunnel Data. NASA Technical Memorandum 89038, 1987
  * Comfort, D. L.; Erikson, W. J.: RIM: A Prototype for a Relational Information Management System. In: NASA Conference Publication 2055. Engineering and Scientific Data Management. Proc. of Conf. held at Hampton, Va., 18 – 19 May 1978
  * Fox, J.: RIM Users Manual. University Computing Services, University of Washington, 1990
  * Johnson, H. R.; Bernhardt, D. L.: Engineering Data Management Activities Within the IPAD Project. In: Bulletin of the Technical Committee on Data Engineering, Vol. 5, No. 2. IEEE Computer Society, June 1982

## Licence
Public Domain
