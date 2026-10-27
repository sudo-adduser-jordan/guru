# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit desktop python-single-r1 xdg

DESCRIPTION="Graphical user interface for ufw"
HOMEPAGE="https://github.com/costales/gufw https://costales.github.io/projects/gufw/"
SRC_URI="https://github.com/costales/gufw/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	net-firewall/ufw
	sys-auth/polkit
	x11-libs/gtk+:3[introspection]
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
"

src_compile() {
	local lang po
	for po in po/*.po; do
		lang=${po##*/}
		lang=${lang%.po}
		if [[ -n ${LINGUAS+set} ]] && ! has "${lang}" ${LINGUAS}; then
			continue
		fi
		msgfmt -o "${T}/${lang}.mo" "${po}" || die
	done
}

src_install() {
	# Upstream hardcodes /usr/share/gufw for its Python modules, UI and
	# media files, and bin/gufw-pkexec hardcodes the path to gufw.py.
	insinto /usr/share/gufw
	doins -r gufw data/ui data/media

	dobin bin/gufw bin/gufw-pkexec

	intltool-merge -d po gufw.desktop.in "${T}/gufw.desktop" || die
	domenu "${T}/gufw.desktop"

	doicon -s 48 data/icons/48x48/apps/gufw.png
	doicon -s scalable data/icons/scalable/apps/gufw.svg

	doman man/gufw.8

	insinto /usr/share/metainfo
	doins data/metainfo/io.github.costales.gufw.metainfo.xml

	insinto /usr/share/polkit-1/actions
	doins policykit/actions/com.ubuntu.pkexec.gufw.policy

	insinto /etc/gufw
	doins -r data/app_profiles

	local lang mo
	for mo in "${T}"/*.mo; do
		[[ -e ${mo} ]] || continue
		lang=${mo##*/}
		lang=${lang%.mo}
		insinto "/usr/share/locale/${lang}/LC_MESSAGES"
		newins "${mo}" gufw.mo
	done

	python_optimize "${ED}/usr/share/gufw"

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
