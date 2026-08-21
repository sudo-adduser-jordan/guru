# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Fast, lightweight Proton VPN client for Linux with a terminal UI"
HOMEPAGE="https://github.com/YourDoritos/pVPN"
SRC_URI="
	amd64? (
		https://github.com/YourDoritos/pVPN/releases/download/v${PV}/pvpnd-linux-amd64 -> ${P}-pvpnd-amd64
		https://github.com/YourDoritos/pVPN/releases/download/v${PV}/pvpn-linux-amd64 -> ${P}-pvpn-amd64
		https://github.com/YourDoritos/pVPN/releases/download/v${PV}/pvpnctl-linux-amd64 -> ${P}-pvpnctl-amd64
	)
	arm64? (
		https://github.com/YourDoritos/pVPN/releases/download/v${PV}/pvpnd-linux-arm64 -> ${P}-pvpnd-arm64
		https://github.com/YourDoritos/pVPN/releases/download/v${PV}/pvpn-linux-arm64 -> ${P}-pvpn-arm64
		https://github.com/YourDoritos/pVPN/releases/download/v${PV}/pvpnctl-linux-arm64 -> ${P}-pvpnctl-arm64
	)
	https://github.com/YourDoritos/pVPN/archive/refs/tags/v${PV}.tar.gz -> ${P}-src.tar.gz
"

S="${WORKDIR}/${P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RESTRICT="strip mirror"

RDEPEND="net-firewall/nftables"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"

DOCS=( README.md SECURITY.md )

src_install() {
	newbin "${DISTDIR}/${P}-pvpnd-${ARCH}" pvpnd
	newbin "${DISTDIR}/${P}-pvpn-${ARCH}" pvpn
	newbin "${DISTDIR}/${P}-pvpnctl-${ARCH}" pvpnctl

	sed 's|ExecStart=.*|ExecStart=/usr/bin/pvpnd|' "${S}/dist/pvpnd.service" > pvpnd.service || die
	systemd_dounit pvpnd.service

	einstalldocs
}

pkg_preinst() {
	enewgroup pvpn
}

pkg_postinst() {
	elog "Add your user to the 'pvpn' group to use pvpn without root:"
	elog "  sudo usermod -aG pvpn \${USER}"
	elog "Then log out and back in (or run: newgrp pvpn)."
	elog ""
	elog "Start and enable the daemon:"
	elog "  sudo systemctl enable --now pvpnd"
	elog ""
	elog "Then launch the TUI with: pvpn"
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		ewarn "The 'pvpn' system group was not removed automatically."
		ewarn "To remove it: sudo groupdel pvpn"
	fi
}
