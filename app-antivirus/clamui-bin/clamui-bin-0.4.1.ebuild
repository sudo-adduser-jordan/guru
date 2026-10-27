# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit desktop python-single-r1 xdg

DESCRIPTION="Modern GTK4/libadwaita graphical interface for ClamAV (AppImage build)"
HOMEPAGE="https://github.com/linx-systems/clamui https://clamui.com/"
SRC_URI="https://github.com/linx-systems/clamui/releases/download/v${PV}/ClamUI-${PV}-x86_64.AppImage -> ${P}.AppImage"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror strip bindist"

QA_PREBUILT="*"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-antivirus/clamav-1.4.3[clamapp]
	${PYTHON_DEPS}
	sys-auth/polkit
	x11-misc/xdg-utils
"

src_unpack() {
	cp "${DISTDIR}/${P}.AppImage" "${WORKDIR}/" || die
	chmod +x "${WORKDIR}/${P}.AppImage" || die
	"${WORKDIR}/${P}.AppImage" --appimage-extract || die "Failed to extract AppImage"
	mv squashfs-root clamui || die
}

src_install() {
	# Keep the bundled runtime intact and install it under /opt. AppRun
	# resolves its own location, so the /usr/bin symlink works.
	dodir /opt
	cp -a "${S}/clamui" "${ED}/opt/" || die
	# The AppImage contains world-writable files; normalize them while
	# preserving the executable bits.
	find "${ED}/opt/clamui" -type f -exec chmod go-w {} + || die
	find "${ED}/opt/clamui" -type d -exec chmod go-w {} + || die
	fperms +x /opt/clamui/AppRun /opt/clamui/AppRun.wrapped

	dosym ../../opt/clamui/AppRun /usr/bin/clamui

	domenu "${S}/clamui/usr/share/applications/io.github.linx_systems.ClamUI.desktop"
	doicon -s 128 "${S}/clamui/usr/share/icons/hicolor/128x128/apps/io.github.linx_systems.ClamUI.png"
	doicon -s scalable "${S}/clamui/usr/share/icons/hicolor/scalable/apps/io.github.linx_systems.ClamUI.svg"

	insinto /usr/share/metainfo
	doins "${S}/clamui/usr/share/metainfo/io.github.linx_systems.ClamUI.metainfo.xml"

	# Install the privileged helper and polkit policy with the Python
	# runtime bundled in the AppImage. The generated wrapper uses the
	# system /usr/bin/python3 (stdlib only).
	local site="${S}/clamui/usr/lib/python3.12/site-packages"
	PYTHONHOME="${S}/clamui/usr" \
	PYTHONPATH="${site}" \
	"${S}/clamui/usr/bin/python3" - "${ED}" <<-EOF || die
	import sys
	from src.cli.install_helper import install_privileged_helper

	ok, msg = install_privileged_helper(sys.argv[1])
	if not ok:
	    raise SystemExit(msg)
	EOF
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
