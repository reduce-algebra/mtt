#! /usr/bin/make -f

# Destinations compliant with Filesystem Hierarchy Standard (FHS) 2.1
# DESTDIR prefix required by Debian build process
CONFDIR=$(DESTDIR)/etc
PROGDIR=$(DESTDIR)/usr/bin
INSTDIR=$(DESTDIR)/usr/share/mtt

# DOCPATH and INFOPATH required by doc/Makefile
DOCDIR=$(DESTDIR)/usr/share/doc/mtt
INFODIR=$(DESTDIR)/usr/share/info

configure: configure-stamp
configure-stamp:
	@touch configure-stamp

build: configure mtt.sh xmtt.sh build-stamp

build-cc:
	@cd cc ; make -s build

build-doc:
	@cd doc ; make -s all

build-stamp:
	@touch build-stamp

clean:
	@touch clean.sh
	@-chmod a+x clean.sh
	@./clean.sh
	@rm -f clean.sh

clean-cc:
	@touch clean-cc.sh
	@-chmod a+x clean-cc.sh
	@./clean-cc.sh
	@rm -f clean-cc.sh

clean-conf:
	@touch clean-conf.sh
	@-chmod a+x clean-conf.sh
	@./clean-conf.sh
	@rm -f clean-conf.sh

clean-doc:
	@touch clean-doc.sh
	@-chmod a+x clean-doc.sh
	@./clean-doc.sh
	@rm -f clean-doc.sh
	@cd doc ; make -s clean

distclean: clean clean-cc clean-conf clean-doc
	@-rm -f build-stamp configure-stamp config.log mtt.sh xmtt.sh

install: build clean.sh clean-conf.sh
	@install -d $(INSTDIR) $(CONFDIR) $(PROGDIR)
	@cp -a   bin cc doc lib $(INSTDIR)
	@install bin/mttrc $(CONFDIR)/mtt.conf
	@install mtt.sh  $(PROGDIR)/mtt
	@install xmtt.sh $(PROGDIR)/xmtt

install-cc: build-cc clean-cc.sh
	@install -d $(INSTDIR)/bin/trans
	@install cc/parse_m2cc.exe $(INSTDIR)/bin/trans

install-doc: build-doc clean-doc.sh
	@install -d $(DOCDIR) $(INFODIR)
	@cd doc ; DOCPATH=$(DOCDIR) INFOPATH=$(INFODIR) make -s install-doc
	@cd doc ; install Makefile mtt.info* mtt.pdf mtt.ps.gz $(DOCDIR)
	@install doc/mtt.info* $(INFODIR)

.PHONY: FORCE

clean.sh: FORCE
	@echo '#! /bin/sh'						>>clean.sh
	@echo '# This file is auto-generated - do not edit'		>>clean.sh
	@echo 'rm -f  $(PROGDIR)/mtt $(PROGDIR)/xmtt'			>>clean.sh
	@echo 'rm -fr $(INSTDIR)'					>>clean.sh

clean-cc.sh: FORCE
	@echo '#! /bin/sh'						>>clean-cc.sh
	@echo '# This file is auto-generated - do not edit'		>>clean-cc.sh
	@echo 'rm -f  $(INSTDIR)/bin/trans/parse_m2cc.exe'		>>clean-cc.sh

clean-conf.sh: FORCE
	@echo '#! /bin/sh'						>>clean-conf.sh
	@echo '# This file is auto-generated - do not edit'		>>clean-conf.sh
	@echo 'rm -f  $(CONFDIR)/mtt.conf'				>>clean-conf.sh

clean-doc.sh: FORCE
	@echo '#! /bin/sh'						>>clean-doc.sh
	@echo '# This file is auto-generated - do not edit'		>>clean-doc.sh
	@echo 'rm -fr $(DOCDIR)'					>>clean-doc.sh
	@echo 'rm -f  $(INFODIR)/mtt.info*'				>>clean-doc.sh

mtt.sh.tmp:
	@echo '#! /bin/sh'						> mtt.sh.tmp
	@echo '# This file is auto-generated - do not edit'		>>mtt.sh.tmp
	@echo ''							>>mtt.sh.tmp
	@echo 'mtt_config_file=$(CONFDIR)/mtt.conf'			>>mtt.sh.tmp
	@echo 'mtt_program_dir=$(PROGDIR)'				>>mtt.sh.tmp
	@echo 'mtt_install_dir=$(INSTDIR)'				>>mtt.sh.tmp
	@echo ''							>>mtt.sh.tmp
	@echo '# get site-specific settings'				>>mtt.sh.tmp
	@echo 'if [[ -r $${mtt_config_file} ]]; then'			>>mtt.sh.tmp
	@echo '   . $${mtt_config_file} $${mtt_install_dir} >/dev/null'	>>mtt.sh.tmp
	@echo ''							>>mtt.sh.tmp
	@echo 'elif [[ -r $${mtt_install_dir}/bin/mttrc ]]; then'	>>mtt.sh.tmp
	@echo '   . $${mtt_install_dir}/bin/mttrc $${mtt_install_dir}'	>>mtt.sh.tmp
	@echo 'fi'							>>mtt.sh.tmp
	@echo ''							>>mtt.sh.tmp
	@echo '# get user-specific settings'				>>mtt.sh.tmp
	@echo 'if [[ -r $${HOME}/.mttrc ]]; then'			>>mtt.sh.tmp
	@echo '   . $${HOME}/.mttrc'					>>mtt.sh.tmp
	@echo 'fi'							>>mtt.sh.tmp
	@echo ''							>>mtt.sh.tmp
	@echo '# get directory-specific settings'			>>mtt.sh.tmp
	@echo 'if [[ -r ./.mttrc ]]; then'				>>mtt.sh.tmp
	@echo '   . ./.mttrc'						>>mtt.sh.tmp
	@echo 'fi'							>>mtt.sh.tmp
	@echo ''							>>mtt.sh.tmp

mtt.sh: mtt.sh.tmp
	@cat mtt.sh.tmp bin/mtt						> mtt.sh

xmtt.sh: mtt.sh.tmp
	@cat mtt.sh.tmp bin/xmtt					> xmtt.sh
