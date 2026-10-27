# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit desktop distutils-r1 optfeature xdg

DESCRIPTION="Modern GTK4/libadwaita graphical interface for ClamAV"
HOMEPAGE="https://github.com/linx-systems/clamui https://clamui.com/"
SRC_URI="https://github.com/linx-systems/clamui/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md CHANGELOG.md RELEASE_NOTES.md )

RDEPEND="
	>=app-antivirus/clamav-1.4.3[clamapp]
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
	')
	gui-libs/gtk:4[introspection]
	gui-libs/libadwaita[introspection]
	sys-auth/polkit
	x11-misc/xdg-utils
"
BDEPEND="
	sys-devel/gettext
"

src_prepare() {
	distutils-r1_src_prepare

	# Upstream installs a generic top-level "src" package; use the project
	# name instead, as Debian's packaging does.
	mv src clamui || die
	sed -i \
		-e 's/packages = \["src"\]/packages = ["clamui"]/' \
		-e 's/src\.main:main/clamui.main:main/' \
		-e 's/src\.cli\.scheduled_scan:main/clamui.cli.scheduled_scan:main/' \
		pyproject.toml || die
}

python_install_all() {
	distutils-r1_python_install_all

	domenu "${S}/data/io.github.linx_systems.ClamUI.desktop"
	doicon -s 128 "${S}/icons/io.github.linx_systems.ClamUI.png"
	doicon -s scalable "${S}/icons/io.github.linx_systems.ClamUI.svg"

	insinto /usr/share/metainfo
	doins "${S}/data/io.github.linx_systems.ClamUI.metainfo.xml"

	# Nemo / Nautilus / Dolphin context-menu integration
	insinto /usr/share/nemo/actions
	doins "${S}"/data/io.github.linx_systems.ClamUI{,-virustotal}.nemo_action

	exeinto /usr/share/clamui/integrations
	doexe "${S}"/scripts/clamui-{scan,virustotal}-nautilus.sh

	local f
	for f in \
		"${S}/data/io.github.linx_systems.ClamUI.service.desktop" \
		"${S}/data/io.github.linx_systems.ClamUI-virustotal.desktop"
	do
		insinto /usr/share/kio/servicemenus
		doins "${f}"
		insinto /usr/share/kservices5/ServiceMenus
		doins "${f}"
	done

	# Translations
	local lang
	for lang in $(sed -e 's/#.*//' "${S}/po/LINGUAS"); do
		if [[ -n ${LINGUAS+set} ]] && ! has "${lang}" ${LINGUAS}; then
			continue
		fi
		msgfmt -o "${T}/${lang}.mo" "${S}/po/${lang}.po" || die
		insinto "/usr/share/locale/${lang}/LC_MESSAGES"
		newins "${T}/${lang}.mo" clamui.mo
	done

	# Privileged pkexec helper, self-contained helper modules, and polkit policy.
	# Reuse upstream's installer so this stays in sync with the app version.
	local -x PYTHONPATH="${S}"
	"${EPYTHON}" - "${ED}" <<-EOF || die
	import sys
	from clamui.cli.install_helper import install_privileged_helper

	ok, msg = install_privileged_helper(sys.argv[1])
	if not ok:
	    raise SystemExit(msg)
	EOF
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	optfeature "system tray integration" "dev-libs/libdbusmenu[introspection]"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
