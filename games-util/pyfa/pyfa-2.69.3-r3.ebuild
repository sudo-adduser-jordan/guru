# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit desktop python-single-r1 xdg

DESCRIPTION="Python fitting assistant, a ship fitting tool for EVE Online"
HOMEPAGE="https://github.com/pyfa-org/Pyfa"
SRC_URI="https://github.com/pyfa-org/Pyfa/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Pyfa-${PV}"

LICENSE="GPL-3 all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror bindist"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/logbook[${PYTHON_USEDEP}]
		dev-python/markdown2[${PYTHON_USEDEP}]
		dev-python/matplotlib[wxwidgets,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/python-jose[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-cache[${PYTHON_USEDEP}]
		dev-python/roman[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/wxpython[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
"
BDEPEND="app-arch/unzip"

src_prepare() {
	# Gentoo ships wxPython 4.2 (wxWidgets 3.2); upstream needs the 4.3
	# app-level Appearance API. Tolerate its absence (light theme) with
	# a code edit instead of a patch file, so upstream CRLF line
	# endings cannot break it.
	"${EPYTHON}" - gui/utils/dark.py <<-"EOF" || die "wx compat edit failed"
	import sys
	path = sys.argv[1]
	old = "    if app is None:\n        return False\n\n    theme = ThemeSettings.getInstance().get('theme')\n"
	new = "    if app is None:\n        return False\n\n    # wxPython < 4.3 has no Appearance API; use light theme\n    if not hasattr(wx.App, \"Appearance\"):\n        return True\n\n    theme = ThemeSettings.getInstance().get('theme')\n"
	data = open(path, encoding="utf-8").read()
	assert data.count(old) == 1, "compat anchor not unique"
	open(path, "w", encoding="utf-8", newline="").write(data.replace(old, new))
	EOF

	default

	# Point the program at the system-wide install location instead of
	# the source tree.
	cat > configforced.py <<-EOF || die
		# Gentoo-specific settings
		pyfaPath = u'${EPREFIX}/usr/share/pyfa'
		gameDB = u'${EPREFIX}/usr/share/pyfa/eve.db'
		imgsZIP = u'${EPREFIX}/usr/share/pyfa/imgs.zip'
	EOF

	# Compile translations and build the static game database.
	"${EPYTHON}" scripts/compile_lang.py || die "compile_lang.py failed"
	"${EPYTHON}" ./db_update.py || die "db_update.py failed"
}

src_install() {
	einfo "Compressing images ..."
	pushd imgs || die
	zip -q -r ../imgs.zip . || die "zip failed"
	popd || die

	insinto /usr/share/pyfa
	doins -r config.py configforced.py db_update.py pyfa.py version.yml
	doins -r eve.db imgs.zip
	doins -r eos graphs gui locale service utils

	cat > "${T}/pyfa" <<-EOF || die
		#!/bin/sh
		exec "${EPYTHON}" "${EPREFIX}/usr/share/pyfa/pyfa.py" "\$@"
	EOF
	newbin "${T}/pyfa" pyfa

	newicon -s 32 imgs/gui/pyfa.png pyfa.png
	newicon -s 64 imgs/gui/pyfa64.png pyfa.png
	domenu "${FILESDIR}/pyfa.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
