# make rim libs (generic instructions)

#------------------------------------------------------------------#
CC       = cc
FC       = f2c
PREFIX   = /usr/local
LDFLAGS  = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
RANLIB   = ranlib
LDLIBS   = /usr/local/lib/libf2c.a -lm -lf2c
EXTRA    = time_date.o
LIBEXTRA = time_date.o
LIBRIM   = librim.a
AR       = ar rv
RAN      = ranlib

# Files used by Rim and associates

# Main programs

# Module not used
UNUSED = ncodei.o getloc.o

MAINS = rim.o rime.o lxtest.o helpgen.o

# Subroutines used by Rim and Rime

RIMSUBS := adddat.o amsg.o ascan.o ascchr.o ascdat.o asctxt.o atoi.o ator.o
RIMSUBS += attadd.o attdel.o attget.o attnew.o attpag.o attput.o blkchg.o
RIMSUBS += blkcln.o blkclr.o blkdef.o blkdsp.o blkdwn.o blkext.o blkloc.o
RIMSUBS += blkmov.o blknxt.o blkup.o btadd.o btget.o btinit.o btlki.o btlkr.o
RIMSUBS += btmove.o btput.o btrep.o btsert.o build.o change.o chgdat.o chgpsw.o
RIMSUBS += chkatt.o chkfil.o chkrel.o chrasc.o chtype.o datjul.o dbdefn.o
RIMSUBS += dbload.o dbopcl.o dbopen.o deldat.o deldup.o delete.o delrow.o dmsg.o
RIMSUBS += dtfenc.o dtfspl.o dtor.o eq.o eqkeyw.o eqtok.o f1clo.o f1opn.o f2clo.o
RIMSUBS += f2opn.o f3clo.o f3opn.o filch.o fmtdec.o getdat.o getkca.o gett.o
RIMSUBS += gtsort.o htoi.o iexp.o imsg.o isect.o itoa.o itoh.o join.o joirel.o
RIMSUBS += juldat.o kmpard.o kmpari.o kmparr.o kmpart.o kompxx.o lfind.o lkstr.o
RIMSUBS += lnkadd.o lnkget.o lnkpag.o lnkput.o loadfm.o loadit.o loadmv.o
RIMSUBS += locase.o locatt.o locboo.o loclnk.o locmac.o locprm.o locrel.o
RIMSUBS += locvar.o lodele.o lodlnk.o lodpas.o lodrec.o lodrel.o lstrel.o
RIMSUBS += lstrng.o lxcmnt.o lxdate.o lxedit.o lxfmt.o lxinit.o lxlenw.o lxsrec.o
RIMSUBS += lxwrec.o macdef.o macexp.o motscn.o msg.o msgcmv.o ndigit.o ne.o
RIMSUBS += nxtchr.o nxtchx.o nxtcrd.o nxttok.o parse.o parval.o pgbres.o pgbsto.o
RIMSUBS += pgcexp.o pgcomp.o pgcprt.o pgeexp.o pgeprt.o pgexec.o pgstor.o pject.o
RIMSUBS += prckey.o prjtup.o prmset.o prompt.o ptrs.o putdat.o putt.o reladd.o
RIMSUBS += relget.o relpag.o relput.o remkey.o remlnk.o remrel.o report.o reuse.o
RIMSUBS += rformt.o rimcmd.o rioclo.o rioin.o rioopn.o rioout.o ritoa.o rmclos.o
RIMSUBS += rmcons.o rmdate.o rmhelp.o rminit.o rmlook.o rmpii.o rmqery.o rmres.o
RIMSUBS += rmsav.o rmset.o rmshow.o rmtime.o rmtypt.o rmvarc.o rmzip.o rnamea.o
RIMSUBS += rnamel.o rnamer.o roun.o rtoa.o rtod.o selatt.o select.o selout.o
RIMSUBS += selput.o selrel.o selrpt.o selsrt.o selwhr.o setin.o setout.o sgtlnk.o
RIMSUBS += sort.o strasc.o strmov.o subtrc.o swcon.o swcost.o swfilo.o swflfs.o
RIMSUBS += swhart.o swhrtd.o swhrti.o swhrtr.o swicst.o swidcp.o swiicp.o
RIMSUBS += swinpo.o swircp.o switcp.o swshel.o swsink.o swsmfl.o swsmvl.o
RIMSUBS += swunlo.o swunvl.o swvacp.o swvlfs.o swvllo.o syscmd.o syscom.o
RIMSUBS += sysdbg.o sysdbn.o sysdel.o sysexi.o sysini.o systrp.o tioclo.o tioin.o
RIMSUBS += tioopn.o tioout.o tokdsp.o toktyp.o toled.o toler.o tuplrc.o typer.o
RIMSUBS += undata.o undef.o union.o unload.o unpass.o upcase.o varadd.o warn.o
RIMSUBS += whetol.o wheval.o whrnam.o xhibit.o zeroit.o zmove.o $(EXTRA)

#------------------------------------------------------------------#

# Subroutines in the user programmable interface library

LIBRIMSUBS := adddat.o ascan.o ascchr.o ascdat.o asctxt.o atoi.o ator.o attadd.o
LIBRIMSUBS += attdel.o attget.o attnew.o attpag.o attput.o blkchg.o blkcln.o
LIBRIMSUBS += blkclr.o blkdef.o blkdsp.o blkdwn.o blkext.o blkloc.o blkmov.o
LIBRIMSUBS += blknxt.o blkup.o btadd.o btget.o btinit.o btlki.o btlkr.o btmove.o
LIBRIMSUBS += btput.o btrep.o btsert.o build.o change.o chgdat.o chgpsw.o
LIBRIMSUBS += chkatt.o chkfil.o chkrel.o chrasc.o chtype.o datjul.o dbdefn.o
LIBRIMSUBS += dbload.o dbopcl.o dbopen.o deldat.o deldup.o delete.o delrow.o
LIBRIMSUBS += dtfenc.o dtfspl.o dtor.o eq.o eqkeyw.o eqtok.o filch.o fmtdec.o
LIBRIMSUBS += f1clo.o f1opn.o f2clo.o f2opn.o f3clo.o f3opn.o getdat.o getkca.o
LIBRIMSUBS += gett.o gtsort.o htoi.o iexp.o isect.o itoa.o itoh.o join.o joirel.o
LIBRIMSUBS += juldat.o kmpard.o kmpari.o kmparr.o kmpart.o kompxx.o lfind.o
LIBRIMSUBS += lkstr.o locase.o locatt.o locboo.o locmac.o locprm.o locrel.o
LIBRIMSUBS += lodele.o lodpas.o lodrec.o lodrel.o lstrel.o lstrng.o lxcmnt.o
LIBRIMSUBS += lxdate.o lxedit.o lxfmt.o lxinit.o lxlenw.o lxsrec.o lxwrec.o
LIBRIMSUBS += macdef.o macexp.o motscn.o ndigit.o ne.o nxtchr.o nxtchx.o nxttok.o
LIBRIMSUBS += parse.o parval.o pilib.o pilibx.o pject.o prckey.o prjtup.o ptrs.o
LIBRIMSUBS += putdat.o putt.o reladd.o relget.o relpag.o relput.o remkey.o
LIBRIMSUBS += remrel.o reuse.o rformt.o rioclo.o rioin.o rioopn.o rioout.o ritoa.o
LIBRIMSUBS += rmclos.o rmcons.o rmdate.o rminit.o rmlook.o rmpii.o rmqery.o
LIBRIMSUBS += rmres.o rmsav.o rmset.o rmtime.o rmtypt.o rmvarc.o rmxdel.o
LIBRIMSUBS += rmxget.o rmxlod.o rmxput.o rnamea.o rnamer.o roun.o rtoa.o rtod.o
LIBRIMSUBS += selrel.o selsrt.o selwhr.o sort.o strasc.o strmov.o subtrc.o
LIBRIMSUBS += swcon.o swcost.o swfilo.o swflfs.o swhart.o swhrtd.o swhrti.o
LIBRIMSUBS += swhrtr.o swicst.o swidcp.o swiicp.o swinpo.o swircp.o switcp.o
LIBRIMSUBS += swshel.o swsink.o swsmfl.o swsmvl.o swunlo.o swunvl.o swvacp.o
LIBRIMSUBS += swvlfs.o swvllo.o syscmd.o syscom.o sysdbg.o sysdbn.o sysdel.o
LIBRIMSUBS += tokdsp.o toktyp.o toled.o toler.o tuplrc.o typer.o union.o upcase.o
LIBRIMSUBS += whetol.o wheval.o whrnam.o xhibit.o zeroit.o zmove.o $(LIBEXTRA)

RXFILES = rmxget.o rmxput.o rmxlod.o rmxdel.o

#----------------------------------------------------------------------#

.SUFFIXES = .o .f .c
.f.o:
	$(FC) -c -w $*.f
	$(CC) $(LDFLAGS) -c -w $*.c

all:
	make rim
	make rime
	make rimh
	make $(LIBRIM)

rim: rim.o $(RIMSUBS)
	$(CC) $(LDFLAGS) -o rim rim.o $(RIMSUBS) $(LDLIBS)

rime: rime.o $(RIMSUBS)
	$(CC) $(LDFLAGS) -o rime rime.o $(RIMSUBS) $(LDLIBS)

rimh: rimh.o librim.a
	$(CC) $(LDFLAGS) -o rimh rimh.o librim.a $(LDLIBS)

lxtest: lxtest.o $(RIMSUBS)
	$(CC) $(LDFLAGS) -o lxtest lxtest.o $(RIMSUBS) $(LDLIBS)

rimlib: $(RIMSUBS)
	$(AR)  rimlib $(RIMSUBS)
	$(RAN) rimlib

librim.a: $(LIBRIMSUBS) $(LIBEXTRA)
	$(AR) librim.a $(LIBRIMSUBS)
	$(RAN) librim.a

clean:
	rm *.c *.o

#-------------------------------------------------------------------#
