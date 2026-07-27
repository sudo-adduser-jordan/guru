# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Real-time PC power consumption monitor - watts per app and per component"
HOMEPAGE="https://wattseal.com"
SRC_URI="
	amd64? ( https://github.com/Daminoup88/WattSeal/releases/download/v${PV}/WattSeal-linux -> ${P}-linux )
	https://raw.githubusercontent.com/Daminoup88/WattSeal/v${PV}/resources/icon.png -> ${P}-icon.png
"

S="${WORKDIR}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libpcre2
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/vulkan-loader
	sys-apps/dbus
	virtual/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

src_install() {
	newbin "${DISTDIR}/${P}-linux" WattSeal
	newicon "${DISTDIR}/${P}-icon.png" WattSeal.png
	domenu "${FILESDIR}/WattSeal.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "For accurate CPU power measurements (RAPL), run WattSeal with root"
	elog "privileges, e.g. 'sudo /usr/bin/WattSeal'."
	elog
	elog "Optional runtime dependencies:"
	elog "  - NVIDIA GPU power measurement requires x11-drivers/nvidia-drivers"
	elog "  - If rendering issues occur, try 'ICED_BACKEND=tiny-skia /usr/bin/WattSeal'"
}

pkg_postrm() {
	xdg_pkg_postrm
}
