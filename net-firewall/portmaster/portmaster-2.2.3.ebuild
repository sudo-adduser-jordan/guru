# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop systemd xdg

DESCRIPTION="Application firewall and network monitor"
HOMEPAGE="https://github.com/safing/portmaster"
SRC_URI="
	https://updates.safing.io/latest/linux_amd64/start/portmaster-start -> ${P}-start
	https://raw.githubusercontent.com/safing/portmaster-packaging/master/linux/portmaster_logo.png -> ${P}-logo.png
"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror strip"

QA_PREBUILT="/opt/safing/portmaster/portmaster-start"

src_unpack() {
	:
}

src_install() {
	exeinto /opt/safing/portmaster
	newexe "${DISTDIR}/${P}-start" portmaster-start
	keepdir /opt/safing/portmaster
	dosym -r /opt/safing/portmaster/portmaster-start /usr/bin/portmaster-start

	newinitd "${FILESDIR}"/portmaster.initd portmaster
	newconfd "${FILESDIR}"/portmaster.confd portmaster
	systemd_dounit "${FILESDIR}"/portmaster.service

	domenu "${FILESDIR}"/portmaster.desktop
	domenu "${FILESDIR}"/portmaster-notifier.desktop
	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/portmaster-notifier.desktop
	newicon -s 512 "${DISTDIR}/${P}-logo.png" portmaster.png
}

portmaster_data_dir() {
	echo "${EROOT}/opt/safing/portmaster"
}

portmaster_update_components() {
	einfo "Downloading Portmaster components (~300MB) ..."
	if ! "$(portmaster_data_dir)"/portmaster-start \
		--data "$(portmaster_data_dir)" update
	then
		ewarn "Failed to download Portmaster components."
		ewarn "Run: portmaster-start --data=/opt/safing/portmaster update"
		return 1
	fi
}

portmaster_enable_service() {
	if [[ -d /run/systemd/system ]] && type systemctl >/dev/null 2>&1; then
		systemctl daemon-reload || die
		systemctl enable --now portmaster.service \
			|| ewarn "Failed to enable/start portmaster.service"
	elif type rc-update >/dev/null 2>&1; then
		rc-update add portmaster default \
			|| ewarn "Failed to add portmaster to the default runlevel"
		if [[ -d /run/openrc ]]; then
			rc-service portmaster start \
				|| ewarn "Failed to start portmaster"
		fi
	else
		ewarn "Could not detect systemd or OpenRC; enable portmaster manually."
	fi
}

portmaster_disable_service() {
	if [[ -d /run/systemd/system ]] && type systemctl >/dev/null 2>&1; then
		systemctl disable --now portmaster.service >/dev/null 2>&1 || :
	elif type rc-update >/dev/null 2>&1; then
		if [[ -d /run/openrc ]]; then
			rc-service portmaster stop >/dev/null 2>&1 || :
		fi
		rc-update del portmaster default >/dev/null 2>&1 || :
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ${MERGE_TYPE} != buildonly ]]; then
		portmaster_update_components
		portmaster_enable_service
	fi

	elog "NetworkManager is recommended for better integration."
	elog "Do not run Portmaster together with another host firewall such as firewalld."
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${MERGE_TYPE} != buildonly ]]; then
		portmaster_disable_service
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
