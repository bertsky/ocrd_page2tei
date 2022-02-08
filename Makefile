# ocrd_page2tei installation makefile
#
# For installation via shell-script:
VIRTUAL_ENV ?= $(CURDIR)/local
# copy `ocrd-make` here:
BINDIR = $(abspath $(VIRTUAL_ENV))/bin
# copy the makefiles here:
SHAREDIR = $(abspath $(VIRTUAL_ENV))/share/ocrd_page2tei

# we need associative arrays, process substitution etc.
# also, fail on failed intermediates as well:
SHELL = bash -o pipefail

help:
	@echo "Installing ocrd_page2tei:"
	@echo
	@echo "  Usage:"
	@echo "  make [OPTIONS] TARGET"
	@echo
	@echo "  Targets:"
	@echo "  * help        (this message)"
	@echo "  * deps-ubuntu (install system dependencies)"
	@echo "  * deps        (download and unpack Saxon library and page2tei repo)"
	@echo "  * install     (copy 'ocrd-page2tei' script and XSL scripts to"
	@echo "  *              VIRTUAL_ENV=$(VIRTUAL_ENV)"
	@echo "  *              from repository workdir)"
	@echo "  * uninstall   (remove 'ocrd-page2tei' script and XSL scripts from"
	@echo "  *              VIRTUAL_ENV=$(VIRTUAL_ENV))"
	@echo
	@echo "  Variables:"
	@echo
	@echo "  * VIRTUAL_ENV: directory prefix to use for installation"

.PHONY: help

deps-ubuntu:
	apt-get -y install wget curl unzip openjdk-8-jre-headless

SAXON = https://sourceforge.net/projects/saxon/files/Saxon-HE/10/Java/SaxonHE10-6J.zip
SAXONZIP = $(notdir $(SAXON))
SAXONLIB = saxon-he-10.6.jar
$(SAXONLIB): $(SAXONZIP)
	unzip -n $< $(SAXONLIB)
$(SAXONZIP):
	wget -O $@ $(SAXON) || curl -L -o $@ $(SAXON)

# Update OCR-D/assets and OCR-D/spec resp.
repo/page2tei: always-update
	git submodule sync --recursive $@
	if git submodule status --recursive $@ | grep -qv '^ '; then \
		git submodule update --init --recursive $@ && \
		touch -c $@; \
	fi

XSLS = $(patsubst %,repo/page2tei/%,string-pack.xsl page2tei-0.xsl)
$(XSLS): repo/page2tei

PROGS = ocrd-page2tei
install-bin: $(PROGS:%=$(BINDIR)/%) | $(BINDIR)

$(PROGS:%=$(BINDIR)/%): $(BINDIR)/%: %
	sed 's,^SHAREDIR=.*,SHAREDIR="$(SHAREDIR)",;s,^SAXONLIB=.*,SAXONLIB=$(SAXONLIB),' < $< > $@
	chmod +x $@

$(BINDIR) $(SHAREDIR):
	@mkdir $@

install: install-bin | $(SHAREDIR) $(XSLS) $(SAXONLIB)
	cp -Lf -t $(SHAREDIR) $(XSLS) $(SAXONLIB) ocrd-tool.json

uninstall:
	$(RM) $(PROGS:%=$(BINDIR)/%)
	$(RM) -r $(SHAREDIR)

deps: $(SAXONLIB) repo/page2tei

.PHONY: deps-ubuntu deps install install-bin uninstall always-update

# do not search for implicit rules here:
%/Makefile: ;
Makefile: ;
ocrd-tool.json: ;
$(PROGS): ;
