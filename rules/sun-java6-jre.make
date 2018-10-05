# -*-makefile-*-
#
# Copyright (C) 2007 by Bjoern Buerger <b.buerger@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ARCH_X86)-$(PTXCONF_SUN_JAVA6_JRE) += sun-java6-jre

#
# Paths and names
#
SUN_JAVA6_JRE_VERSION		:= 1.6.0.02
SUN_JAVA6_JRE_MD5		:= 0d30636b5cd23e161da5eda9409f02d5
SUN_JAVA6_JRE			:= jre-6u2-linux-i586
SUN_JAVA6_JRE_SOURCE		:= $(SRCDIR)/$(SUN_JAVA6_JRE).bin
SUN_JAVA6_JRE_URL		:= http://javadl.sun.com/webapps/download/AutoDL?BundleId=11284
SUN_JAVA6_JRE_DIR		:= $(BUILDDIR)/$(SUN_JAVA6_JRE)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/sun-java6-jre.extract:
	@$(call targetinfo)
	@$(call clean, $(SUN_JAVA6_JRE_DIR))
	magic(){ sh $(SUN_JAVA6_JRE_SOURCE) ; };						\
	[ -d $(SUN_JAVA6_JRE_DIR) ] || mkdir -p $(SUN_JAVA6_JRE_DIR);				\
	cd $(SUN_JAVA6_JRE_DIR)	; 								\
	case $$? in										\
	(0) 											\
		echo "extracting java shell archive (pwd is `pwd`)";				\
		echo "$(PTXCONF_SUN_JAVA6_JRE_LICENSE_ACCEPT_STRING)" | magic ;			\
	;;											\
	(*)	echo "an error occurred"; exit 1 ;						\
	;;											\
	esac
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

SUN_JAVA6_JRE_PATH	:= PATH=$(CROSS_PATH)
SUN_JAVA6_JRE_ENV	:= $(CROSS_ENV)

$(STATEDIR)/sun-java6-jre.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/sun-java6-jre.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sun-java6-jre.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sun-java6-jre.targetinstall:
	@$(call targetinfo)

	@$(call install_init, sun-java6-jre)
	@$(call install_fixup, sun-java6-jre,PRIORITY,optional)
	@$(call install_fixup, sun-java6-jre,SECTION,base)
	@$(call install_fixup, sun-java6-jre,AUTHOR,"autogenerated from sun package")
	@$(call install_fixup, sun-java6-jre,DESCRIPTION,missing)

	# derived from ancillary file installation
	 @uid=$$(id -u); gid=$$(id -g);	\
	  (cd $(SUN_JAVA6_JRE_DIR); find jre* | grep -v "\.svn")													\
	| while read i; do																		\
		read fuid fgid fperm < <(stat -c "%u %g %a" $(SUN_JAVA6_JRE_DIR)/$$i);											\
		if [ $$fuid -eq $$uid ]; then fuid=0; fi;														\
		if [ $$fgid -eq $$gid ]; then fgid=0; fi;														\
		ft=$$( LANG=C stat -c %F $(SUN_JAVA6_JRE_DIR)/$$i );													\
		case "$$ft" in																		\
		"regular file"|"regular empty file")															\
			$(call install_copy, sun-java6-jre, $$fuid, $$fgid, $$fperm, $(SUN_JAVA6_JRE_DIR)/$$i, $(PTXCONF_SUN_JAVA6_JRE_TARGET_PREFIX)/$$i);;		\
		"directory")																		\
			$(call install_copy, sun-java6-jre, $$fuid, $$fgid, $$fperm, $(PTXCONF_SUN_JAVA6_JRE_TARGET_PREFIX)/$$i);; 					\
		"symbolic link")																	\
			target=$$( readlink $(SUN_JAVA6_JRE_DIR)/$$i );													\
			$(call install_link, sun-java6-jre, $$target, $(PTXCONF_SUN_JAVA6_JRE_TARGET_PREFIX)/$$i);;							\
		*)																			\
			echo "ERROR: File '$$ft' type of '$$i' not supported";												\
			exit 1;;																	\
		esac ;																			\
	done

	@$(call install_finish, sun-java6-jre)
	@$(call touch)

# vim: syntax=make
