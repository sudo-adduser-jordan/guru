# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The lazier way to manage everything docker"
HOMEPAGE="https://github.com/jesseduffield/lazydocker"
SRC_URI="https://github.com/jesseduffield/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
# dependency licenses:
LICENSE+=" Apache-2.0 BSD ISC MIT "
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-lang/go-1.22.0"
RDEPEND="app-containers/docker-cli"

DOCS=( {CODE-OF-CONDUCT,CONTRIBUTING,README}.md docs )

RESTRICT="test"

src_compile() {
	ego build -o "bin/${PN}" \
		-ldflags "-X main.version=${PV} -X main.commit=${PV} -X main.buildSource=ebuild"
}

src_install() {
	dobin "bin/${PN}"
	einstalldocs
}
