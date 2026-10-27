# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Fast, lightweight Proton VPN client for Linux with a terminal UI"
HOMEPAGE="https://github.com/YourDoritos/pVPN"
SRC_URI="https://github.com/YourDoritos/pVPN/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/pVPN-${PV}"

LICENSE="GPL-3 BSD BSD-2 MIT Apache-2.0 ISC MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="net-firewall/nftables"
BDEPEND=">=dev-lang/go-1.26.6 app-arch/unzip"

# EGO_SUM is deprecated in favour of a dependency tarball, but this keeps
# the package self-contained without hosting a tarball elsewhere.
EGO_SUM=(
	"github.com/atotto/clipboard v0.1.4"
	"github.com/atotto/clipboard v0.1.4/go.mod"
	"github.com/aymanbagabas/go-osc52/v2 v2.0.1"
	"github.com/aymanbagabas/go-osc52/v2 v2.0.1/go.mod"
	"github.com/boombuler/barcode v1.0.1-0.20190219062509-6c824513bacc"
	"github.com/boombuler/barcode v1.0.1-0.20190219062509-6c824513bacc/go.mod"
	"github.com/BurntSushi/toml v1.6.0"
	"github.com/BurntSushi/toml v1.6.0/go.mod"
	"github.com/bwesterb/go-ristretto v1.2.0/go.mod"
	"github.com/charmbracelet/bubbles v1.0.0"
	"github.com/charmbracelet/bubbles v1.0.0/go.mod"
	"github.com/charmbracelet/bubbletea v1.3.10"
	"github.com/charmbracelet/bubbletea v1.3.10/go.mod"
	"github.com/charmbracelet/colorprofile v0.4.1"
	"github.com/charmbracelet/colorprofile v0.4.1/go.mod"
	"github.com/charmbracelet/lipgloss v1.1.0"
	"github.com/charmbracelet/lipgloss v1.1.0/go.mod"
	"github.com/charmbracelet/x/ansi v0.11.6"
	"github.com/charmbracelet/x/ansi v0.11.6/go.mod"
	"github.com/charmbracelet/x/cellbuf v0.0.15"
	"github.com/charmbracelet/x/cellbuf v0.0.15/go.mod"
	"github.com/charmbracelet/x/term v0.2.2"
	"github.com/charmbracelet/x/term v0.2.2/go.mod"
	"github.com/clipperhouse/displaywidth v0.9.0"
	"github.com/clipperhouse/displaywidth v0.9.0/go.mod"
	"github.com/clipperhouse/stringish v0.1.1"
	"github.com/clipperhouse/stringish v0.1.1/go.mod"
	"github.com/clipperhouse/uax29/v2 v2.5.0"
	"github.com/clipperhouse/uax29/v2 v2.5.0/go.mod"
	"github.com/cloudflare/circl v1.1.0/go.mod"
	"github.com/cloudflare/circl v1.6.3"
	"github.com/cloudflare/circl v1.6.3/go.mod"
	"github.com/cronokirby/saferith v0.33.0"
	"github.com/cronokirby/saferith v0.33.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/erikgeiser/coninput v0.0.0-20211004153227-1c3628e74d0f"
	"github.com/erikgeiser/coninput v0.0.0-20211004153227-1c3628e74d0f/go.mod"
	"github.com/godbus/dbus/v5 v5.2.2"
	"github.com/godbus/dbus/v5 v5.2.2/go.mod"
	"github.com/google/btree v1.0.1"
	"github.com/google/btree v1.0.1/go.mod"
	"github.com/google/go-cmp v0.6.0"
	"github.com/google/go-cmp v0.6.0/go.mod"
	"github.com/jackpal/go-nat-pmp v1.0.2"
	"github.com/jackpal/go-nat-pmp v1.0.2/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.3.0"
	"github.com/lucasb-eyer/go-colorful v1.3.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/mattn/go-localereader v0.0.1"
	"github.com/mattn/go-localereader v0.0.1/go.mod"
	"github.com/mattn/go-runewidth v0.0.19"
	"github.com/mattn/go-runewidth v0.0.19/go.mod"
	"github.com/mdlayher/genetlink v1.3.2"
	"github.com/mdlayher/genetlink v1.3.2/go.mod"
	"github.com/mdlayher/netlink v1.7.3-0.20250113171957-fbb4dce95f42"
	"github.com/mdlayher/netlink v1.7.3-0.20250113171957-fbb4dce95f42/go.mod"
	"github.com/mdlayher/socket v0.5.1"
	"github.com/mdlayher/socket v0.5.1/go.mod"
	"github.com/mikioh/ipaddr v0.0.0-20190404000644-d465c8ab6721"
	"github.com/mikioh/ipaddr v0.0.0-20190404000644-d465c8ab6721/go.mod"
	"github.com/muesli/ansi v0.0.0-20230316100256-276c6243b2f6"
	"github.com/muesli/ansi v0.0.0-20230316100256-276c6243b2f6/go.mod"
	"github.com/muesli/cancelreader v0.2.2"
	"github.com/muesli/cancelreader v0.2.2/go.mod"
	"github.com/muesli/termenv v0.16.0"
	"github.com/muesli/termenv v0.16.0/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/pquerna/otp v1.5.0"
	"github.com/pquerna/otp v1.5.0/go.mod"
	"github.com/ProtonMail/bcrypt v0.0.0-20210511135022-227b4adcab57"
	"github.com/ProtonMail/bcrypt v0.0.0-20210511135022-227b4adcab57/go.mod"
	"github.com/ProtonMail/go-crypto v0.0.0-20230321155629-9a39f2531310"
	"github.com/ProtonMail/go-crypto v0.0.0-20230321155629-9a39f2531310/go.mod"
	"github.com/ProtonMail/go-srp v0.0.7"
	"github.com/ProtonMail/go-srp v0.0.7/go.mod"
	"github.com/ProtonVPN/go-vpn-lib v0.0.0-20260324100540-c10475f71a6b"
	"github.com/ProtonVPN/go-vpn-lib v0.0.0-20260324100540-c10475f71a6b/go.mod"
	"github.com/rivo/uniseg v0.4.7"
	"github.com/rivo/uniseg v0.4.7/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.7.0"
	"github.com/stretchr/testify v1.7.0/go.mod"
	"github.com/vishvananda/netlink v1.3.0"
	"github.com/vishvananda/netlink v1.3.0/go.mod"
	"github.com/vishvananda/netns v0.0.4"
	"github.com/vishvananda/netns v0.0.4/go.mod"
	"github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e"
	"github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e/go.mod"
	"github.com/yuin/goldmark v1.4.13/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
	"golang.org/x/crypto v0.51.0"
	"golang.org/x/crypto v0.51.0/go.mod"
	"golang.org/x/crypto v0.7.0/go.mod"
	"golang.org/x/exp v0.0.0-20231006140011-7918f672742d"
	"golang.org/x/exp v0.0.0-20231006140011-7918f672742d/go.mod"
	"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
	"golang.org/x/mod v0.8.0/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
	"golang.org/x/net v0.55.0"
	"golang.org/x/net v0.55.0/go.mod"
	"golang.org/x/net v0.6.0/go.mod"
	"golang.org/x/net v0.8.0/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
	"golang.org/x/sync v0.1.0/go.mod"
	"golang.org/x/sync v0.20.0"
	"golang.org/x/sync v0.20.0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/sys v0.0.0-20210809222454-d867a43fc93e/go.mod"
	"golang.org/x/sys v0.0.0-20211007075335-d3039528d8ac/go.mod"
	"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
	"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
	"golang.org/x/sys v0.10.0/go.mod"
	"golang.org/x/sys v0.2.0/go.mod"
	"golang.org/x/sys v0.45.0"
	"golang.org/x/sys v0.45.0/go.mod"
	"golang.org/x/sys v0.5.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
	"golang.org/x/term v0.5.0/go.mod"
	"golang.org/x/term v0.6.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.37.0"
	"golang.org/x/text v0.37.0/go.mod"
	"golang.org/x/text v0.3.7/go.mod"
	"golang.org/x/text v0.7.0/go.mod"
	"golang.org/x/text v0.8.0/go.mod"
	"golang.org/x/time v0.0.0-20220210224613-90d013bbcef8"
	"golang.org/x/time v0.0.0-20220210224613-90d013bbcef8/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.1.12/go.mod"
	"golang.org/x/tools v0.6.0/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2"
	"golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2/go.mod"
	"golang.zx2c4.com/wireguard v0.0.0-20231211153847-12269c276173"
	"golang.zx2c4.com/wireguard v0.0.0-20231211153847-12269c276173/go.mod"
	"golang.zx2c4.com/wireguard/wgctrl v0.0.0-20241231184526-a9ab2273dd10"
	"golang.zx2c4.com/wireguard/wgctrl v0.0.0-20241231184526-a9ab2273dd10/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20220521103104-8f96da9f5d5e"
	"gopkg.in/yaml.v3 v3.0.0-20220521103104-8f96da9f5d5e/go.mod"
	"gvisor.dev/gvisor v0.0.0-20230927004350-cbd86285d259"
	"gvisor.dev/gvisor v0.0.0-20230927004350-cbd86285d259/go.mod"
)
go-module_set_globals
SRC_URI+=" ${EGO_SUM_SRC_URI}"

DOCS=( README.md SECURITY.md )

src_compile() {
	export CGO_ENABLED=0
	export GOTOOLCHAIN=local

	local ldflags="-X main.version=${PV}"
	ego build -trimpath -ldflags "${ldflags}" -o pvpnd ./cmd/pvpnd || die
	ego build -trimpath -ldflags "${ldflags}" -o pvpn ./cmd/pvpn || die
	ego build -trimpath -ldflags "${ldflags}" -o pvpnctl ./cmd/pvpnctl || die
}

src_test() {
	export GOTOOLCHAIN=local
	ego test ./... || die
}

src_install() {
	dobin pvpnd pvpn pvpnctl

	sed 's|^ExecStart=.*|ExecStart=/usr/bin/pvpnd|' \
		"${S}/dist/pvpnd.service" > "${T}/pvpnd.service" || die
	systemd_dounit "${T}/pvpnd.service"

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
