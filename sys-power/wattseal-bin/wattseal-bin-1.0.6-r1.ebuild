# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Real-time PC power consumption monitor, per-app and per-component"
HOMEPAGE="https://wattseal.com/"
SRC_URI="
	https://github.com/Daminoup88/WattSeal/releases/download/v${PV}/WattSeal-linux -> ${P}-linux
	https://raw.githubusercontent.com/Daminoup88/WattSeal/v${PV}/resources/icon.png -> ${P}-icon.png
"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror strip"

QA_PREBUILT="*"

# The prebuilt binary links GTK3 (tray icon via libappindicator),
# X11/Wayland, fontconfig and friends (see ldd on WattSeal-linux).
RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libayatana-appindicator
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libpng
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	virtual/zlib
"

src_install() {
	# The program chdirs to its own location on startup and keeps its
	# database and log next to the working directory, so running it
	# straight from read-only /usr/bin would fail silently.
	# /usr/bin/wattseal is a wrapper that runs a per-user copy from a
	# writable data directory instead.
	exeinto /usr/libexec/wattseal
	newexe "${DISTDIR}/${P}-linux" wattseal

	cat > "${T}/wattseal" <<-EOF || die
		#!/bin/sh
		data_dir="\${XDG_DATA_HOME:-\$HOME/.local/share}/wattseal"
		mkdir -p "\${data_dir}" || exit 1
		installed="${EPREFIX}/usr/libexec/wattseal/wattseal"
		local_copy="\${data_dir}/wattseal"
		if [ ! -x "\${local_copy}" ] || [ "\${installed}" -nt "\${local_copy}" ]; then
			cp -f "\${installed}" "\${local_copy}" || exit 1
			chmod +x "\${local_copy}" || exit 1
		fi
		cd "\${data_dir}" || exit 1
		exec "\${local_copy}" "\$@"
	EOF
	newbin "${T}/wattseal" wattseal

	domenu "${FILESDIR}/wattseal.desktop"
	newicon "${DISTDIR}/${P}-icon.png" wattseal.png
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "WattSeal stores its database and log in ~/.local/share/wattseal."
	elog "Launch the UI with: wattseal --ui"
}

pkg_postrm() {
	xdg_pkg_postrm
}
