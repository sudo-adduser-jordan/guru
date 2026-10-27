# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Python fitting assistant, a ship fitting tool for EVE Online"
HOMEPAGE="https://github.com/pyfa-org/Pyfa"
SRC_URI="https://github.com/pyfa-org/Pyfa/releases/download/v${PV}/pyfa-v${PV}-linux.AppImage -> ${P}.AppImage"
S="${WORKDIR}"

LICENSE="GPL-3 all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror strip bindist"

QA_PREBUILT="*"

# The AppImage bundles Python, wxWidgets, GTK3 and most other libraries.
# What it expects from the system (verified with ldd) is listed here.
RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	gui-libs/libdecor
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/libpng
	sys-apps/dbus
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

src_unpack() {
	local appimage="${P}.AppImage"
	cp "${DISTDIR}/${appimage}" "${WORKDIR}/" || die
	chmod +x "${WORKDIR}/${appimage}" || die
	"${WORKDIR}/${appimage}" --appimage-extract || die "Failed to extract AppImage"
	mv squashfs-root "${PN}" || die
}

src_install() {
	# Upstream disables the embedded WebView browser on Linux wxGTK
	# (gui/updateDialog.py:webViewAvailable), and its WebKitGTK 4.0
	# libraries are not available in Gentoo, so drop the unused modules.
	rm "${S}/${PN}/usr/lib/python3.14/site-packages/wx/_html2.cpython-314-x86_64-linux-gnu.so" \
		"${S}/${PN}/usr/lib/python3.14/site-packages/wx/libwx_gtk3u_webview-3.3.so.3" || die

	insinto /opt/${PN}
	doins -r "${PN}"/*

	fperms +x /opt/${PN}/AppRun
	find "${ED}/opt/${PN}" -name "*.so*" -exec chmod +x {} +

	dosym ../../opt/${PN}/AppRun /usr/bin/pyfa

	newicon -s 64 "${S}/${PN}/pyfa.png" pyfa.png
	domenu "${FILESDIR}/pyfa.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
