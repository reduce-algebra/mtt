#! /usr/bin/make -f

# DESTDIR prefix required by Debian build process
INSTDIR=$(DESTDIR)/usr/share/mtt/lib/examples

configure: configure-stamp
configure-stamp:
	@touch configure-stamp

build: configure build-stamp
build-stamp:
	@touch build-stamp

clean:
	@touch clean.sh
	@-chmod a+x clean.sh
	@./clean.sh
	@rm -f clean.sh

distclean: clean

install: build clean.sh
	@install -d $(INSTDIR)
	@cp -a $(filter-out CVS Makefile debian, $(wildcard *)) $(INSTDIR)

.PHONY: FORCE

clean.sh: FORCE
	@echo '#! /bin/sh'					>>clean.sh
	@echo '# This file is auto-generated - do not edit'	>>clean.sh
	@echo "rm -f  $(INSTDIR)/examples"			>>clean.sh

