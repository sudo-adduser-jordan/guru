# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Out-of-game asset manager for EVE Online"
HOMEPAGE="http://eve.nikr.net/jeveasset"
SRC_URI="https://github.com/GoldenGnu/jeveassets/releases/download/jeveassets-${PV}/jeveassets-${PV}.zip"
S="${WORKDIR}/jEveAssets"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror"

QA_PREBUILT="*"

RDEPEND=">=virtual/jre-1.8"
BDEPEND="app-arch/unzip"

src_install() {
	# Keep the upstream layout (jeveassets.jar with lib/ and data/
	# alongside it); the program resolves both relative to its
	# working directory.
	insinto /usr/share/${PN}
	doins -r data lib
	doins *.jar *.properties *.txt

	cat > "${T}/jeveassets" <<-EOF || die
		#!/bin/sh
		cd "${EPREFIX}/usr/share/${PN}" || exit 1
		exec java -jar jeveassets.jar "\$@"
	EOF
	newbin "${T}/jeveassets" jeveassets

	domenu "${FILESDIR}/jeveassets-bin.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
