# -*-makefile-*-
#
# Copyright (C) 2013 by Philipp Zabel <p.zabel@pengutronix.de>
#               2014 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_WESTON) += weston

#
# Paths and names
#
WESTON_VERSION	:= 5.0.0
LIBWESTON_MAJOR := 5
WESTON_MD5	:= 752a04ce3c65af4884cfac4e57231bdb
WESTON		:= weston-$(WESTON_VERSION)
WESTON_SUFFIX	:= tar.xz
WESTON_URL	:= http://wayland.freedesktop.org/releases/$(WESTON).$(WESTON_SUFFIX)
WESTON_SOURCE	:= $(SRCDIR)/$(WESTON).$(WESTON_SUFFIX)
WESTON_DIR	:= $(BUILDDIR)/$(WESTON)
WESTON_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
WESTON_CONF_TOOL	:= autoconf
WESTON_CONF_OPT		:= \
	$(CROSS_AUTOCONF_USR) \
	$(GLOBAL_LARGE_FILE_OPTION) \
	--disable-static \
	--enable-shared \
	--disable-devdocs \
	--$(call ptx/endis, PTXCONF_WESTON_GL)-egl \
	--disable-setuid-install \
	--$(call ptx/endis, PTXCONF_WESTON_XWAYLAND)-xwayland \
	--disable-xwayland-test \
	--disable-x11-compositor \
	--$(call ptx/endis, PTXCONF_WESTON_DRM_COMPOSITOR)-drm-compositor \
	--$(call ptx/endis, PTXCONF_WESTON_GL)-wayland-compositor \
	--$(call ptx/endis, PTXCONF_WESTON_HEADLESS_COMPOSITOR)-headless-compositor \
	--$(call ptx/endis, PTXCONF_WESTON_FBDEV_COMPOSITOR)-fbdev-compositor \
	--disable-rdp-compositor \
	--disable-screen-sharing \
	--disable-vaapi-recorder \
	--enable-simple-clients \
	--$(call ptx/endis, PTXCONF_WESTON_GL)-simple-egl-clients \
	--disable-simple-dmabuf-drm-client \
	--disable-simple-dmabuf-v4l-client \
	--enable-clients \
	--enable-resize-optimization \
	--$(call ptx/endis, PTXCONF_WESTON_LAUNCH)-weston-launch \
	--enable-fullscreen-shell \
	--disable-colord \
	--$(call ptx/endis, PTXCONF_WESTON_SYSTEMD_LOGIND)-dbus \
	--$(call ptx/endis, PTXCONF_WESTON_SYSTEMD_LOGIND)-systemd-login \
	--disable-junit-xml \
	--$(call ptx/endis, PTXCONF_WESTON_IVISHELL)-ivi-shell \
	--$(call ptx/endis, PTXCONF_WESTON_WCAP_TOOLS)-wcap-tools \
	--$(call ptx/endis, PTXCONF_WESTON_IVISHELL_EXAMPLE)-demo-clients-install \
	--disable-lcms \
	--$(call ptx/endis, PTXCONF_WESTON_SYSTEMD)-systemd-notify \
	--with-cairo=$(call ptx/ifdef, PTXCONF_WESTON_GL,glesv2,image) \
	--with-jpeg \
	--without-webp

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/weston.install:
	@$(call targetinfo)
	@$(call world/install, WESTON)

	@mkdir -p $(WESTON_PKGDIR)/etc/xdg/weston
ifndef PTXCONF_WESTON_IVISHELL_EXAMPLE
	@bindir="/usr/bin" \
		abs_top_builddir="/usr/bin" \
		libexecdir="/usr/libexec" \
		ptxd_replace_magic "$(WESTON_DIR)/weston.ini.in" > \
		"$(WESTON_PKGDIR)/etc/xdg/weston/weston.ini"
else
	@bindir="/usr/bin" \
		westondatadir="/usr/share/weston" \
		ptxd_replace_magic "$(WESTON_DIR)/ivi-shell/weston.ini.in" > \
		"$(WESTON_PKGDIR)/etc/xdg/weston/weston.ini"
endif

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/weston.targetinstall:
	@$(call targetinfo)

	@$(call install_init, weston)
	@$(call install_fixup, weston,PRIORITY,optional)
	@$(call install_fixup, weston,SECTION,base)
	@$(call install_fixup, weston,AUTHOR,"Philipp Zabel <p.zabel@pengutronix.de>")
	@$(call install_fixup, weston,DESCRIPTION,"wayland reference compositor implementation")

	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-info)
ifdef PTXCONF_WESTON_LAUNCH
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-launch)
endif
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-terminal)

ifdef PTXCONF_WESTON_WCAP_TOOLS
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/wcap-decode)
endif

	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR))
	@$(call install_lib, weston, 0, 0, 0644, libweston-desktop-$(LIBWESTON_MAJOR))
ifdef PTXCONF_WESTON_XWAYLAND
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/xwayland)
endif
ifdef PTXCONF_WESTON_DRM_COMPOSITOR
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/drm-backend)
endif
ifdef PTXCONF_WESTON_HEADLESS_COMPOSITOR
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/headless-backend)
endif
ifdef PTXCONF_WESTON_FBDEV_COMPOSITOR
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/fbdev-backend)
endif
ifdef PTXCONF_WESTON_GL
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/wayland-backend)
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/gl-renderer)
endif
	@$(call install_lib, weston, 0, 0, 0644, weston/desktop-shell)
	@$(call install_lib, weston, 0, 0, 0644, weston/fullscreen-shell)
ifdef PTXCONF_WESTON_IVISHELL
	@$(call install_lib, weston, 0, 0, 0644, weston/ivi-shell)
endif
ifdef PTXCONF_WESTON_SYSTEMD
	@$(call install_lib, weston, 0, 0, 0644, weston/systemd-notify)
endif

	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-simple-im)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-screenshooter)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-desktop-shell)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-keyboard)


	@$(foreach image, \
		border.png \
		icon_window.png \
		pattern.png \
		sign_close.png \
		sign_maximize.png \
		sign_minimize.png \
		terminal.png \
		wayland.png \
		wayland.svg, \
		$(call install_copy, weston, 0, 0, 0644, -, /usr/share/weston/$(image))$(ptx/nl))

ifdef PTXCONF_WESTON_INSTALL_CONFIG
	@$(call install_alternative, weston, 0, 0, 0644, /etc/xdg/weston/weston.ini)
endif

ifdef PTXCONF_WESTON_IVISHELL_EXAMPLE
	@$(call install_lib, weston, 0, 0, 0644, weston/hmi-controller)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-ivi-shell-user-interface)

	@$(foreach image, \
		background.png \
		fullscreen.png \
		home.png \
		icon_ivi_clickdot.png \
		icon_ivi_flower.png \
		icon_ivi_simple-egl.png \
		icon_ivi_simple-shm.png \
		icon_ivi_smoke.png \
		panel.png \
		random.png \
		sidebyside.png \
		tiling.png, \
		$(call install_copy, weston, 0, 0, 0644, -, /usr/share/weston/$(image))$(ptx/nl))

	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-clickdot)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-flower)
ifdef PTXCONF_WESTON_GL
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-simple-egl)
endif
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-simple-shm)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-smoke)
endif

	@$(call install_finish, weston)

	@$(call touch)

# vim: syntax=make
