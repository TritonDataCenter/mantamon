#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2014, Joyent, Inc.
#

#
# Makefile: basic Makefile for template API service
#
# This Makefile is a template for new repos. It contains only repo-specific
# logic and uses included makefiles to supply common targets (javascriptlint,
# jsstyle, restdown, etc.), which are used by other repos as well. You may well
# need to rewrite most of this file, but you shouldn't need to touch the
# included makefiles.
#
# If you find yourself adding support for new targets that could be useful for
# other projects too, you should add these to the original versions of the
# included Makefiles (in eng.git) so that other teams can use them too.
#

#
# Tools
#
MD2MAN			:= md2man-roff
NPM			:= npm
TAP			:= ./node_modules/.bin/tap

#
# Files
#
DOC_FILES	 = index.restdown
JS_FILES	:= $(shell ls *.js) $(shell find lib -name '*.js')
JSON_FILES	 = package.json $(shell find probes -name '*.json')
JSL_CONF_NODE	 = tools/jsl.node.conf
JSL_FILES_NODE	 = $(JS_FILES)
JSSTYLE_FILES	 = $(JS_FILES)
JSSTYLE_FLAGS	 = -f tools/jsstyle.conf

#
# Variables
#

MAN_PAGES       := $(shell ls docs/man)
MAN_OUTDIR      := man/man1
MAN_OUTPAGES=$(MAN_PAGES:%.md=$(MAN_OUTDIR)/%.1)
MAN_ROOT        := docs/man
NODE_PREBUILT_VERSION=v0.10.24

ifeq ($(shell uname -s),SunOS)
	NODE_PREBUILT_CC_VERSION=4.6.2
	NODE_PREBUILT_TAG=zone
endif

include ./tools/mk/Makefile.defs
ifeq ($(shell uname -s),SunOS)
	include ./tools/mk/Makefile.node_prebuilt.defs
else
	include ./tools/mk/Makefile.node.defs
endif
include ./tools/mk/Makefile.smf.defs

#
# Repo-specific targets
#
.PHONY: all
all: $(SMF_MANIFESTS) | $(TAP) $(REPO_DEPS)
	$(NPM) rebuild

$(TAP): | $(NPM_EXEC)
	$(NPM) install

CLEAN_FILES += $(TAP) ./node_modules/tap

.PHONY: test
test: $(TAP)
	$(NPM) test

$(MAN_OUTDIR):
	mkdir -p $@

$(MAN_OUTDIR)/%.1: $(MAN_ROOT)/%.md | $(MAN_OUTDIR)
	$(MD2MAN) $^ > $@

.PHONY: manpages
manpages: $(MAN_OUTPAGES)


include ./tools/mk/Makefile.deps
ifeq ($(shell uname -s),SunOS)
	include ./tools/mk/Makefile.node_prebuilt.targ
else
	include ./tools/mk/Makefile.node.targ
endif
include ./tools/mk/Makefile.smf.targ
include ./tools/mk/Makefile.targ
