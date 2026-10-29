# jentoo overlay

Personal Gentoo overlay maintained by jordan, tracking
[gentoo/guru](https://github.com/gentoo/guru) upstream plus a small set of
custom packages.

Upstream base: `1c914d790` (`net-im/chatterino: update expected-lite bundled
library`, 2026-10-25).

## Packages

| Package | Version | Description |
|---|---|---|
| `app-antivirus/clamui` | 0.4.1 | Modern GTK4/libadwaita graphical interface for ClamAV ([upstream](https://github.com/linx-systems/clamui)) |
| `app-antivirus/clamui-bin` | 0.4.1 | AppImage build of ClamUI, the GTK4/libadwaita ClamAV frontend ([upstream](https://github.com/linx-systems/clamui)) |
| `app-containers/lazydocker` | 0.25.2 | The lazier way to manage everything docker ([upstream](https://github.com/jesseduffield/lazydocker)) |
| `app-misc/desktop-plus-bin` | 3.6.8.1 | GitHub Desktop fork with advanced functionality and improvements ([upstream](https://github.com/desktop-plus/desktop-plus)) |
| `dev-util/opencode-desktop-bin` | 2.2.0 | Open source AI coding agent, desktop application ([upstream](https://github.com/anomalyco/opencode)) |
| `games-util/jeveassets-bin` | 8.2.2 | Out-of-game asset manager for EVE Online ([upstream](https://github.com/GoldenGnu/jeveassets)) |
| `games-util/pyfa` + `games-util/pyfa-bin` | 2.69.3 | Python fitting assistant, a ship fitting tool for EVE Online ([upstream](https://github.com/pyfa-org/Pyfa)) |
| `net-firewall/gufw` | 26.04 | Graphical user interface for ufw ([upstream](https://github.com/costales/gufw)) |
| `net-firewall/portmaster` | 2.2.3 | Application firewall and network monitor ([upstream](https://github.com/safing/portmaster)) |
| `net-vpn/pvpn` | 0.2.10 | Fast, lightweight Proton VPN client for Linux with a terminal UI, built from source ([upstream](https://github.com/YourDoritos/pVPN)) |
| `net-vpn/pvpn-bin` | 0.2.10 | Fast, lightweight Proton VPN client for Linux with a terminal UI, prebuilt ([upstream](https://github.com/YourDoritos/pVPN)) |
| `sys-power/wattseal` + `sys-power/wattseal-bin` | 1.0.6 | Real-time PC power consumption monitor, per-app and per-component ([upstream](https://github.com/Daminoup88/WattSeal)) |

### Source and binary variants

| Package | Source | `-bin` | Pair? |
|---|---|---|---|
| `app-antivirus/clamui` | ✅ | ✅ (`clamui-bin`) | ✅ |
| `app-containers/lazydocker` | ✅ | ❌ | source only |
| `app-misc/desktop-plus-bin` | ❌ | ✅ | bin only |
| `dev-util/opencode-desktop-bin` | ❌ | ✅ | bin only |
| `games-util/jeveassets-bin` | ❌ | ✅ | bin only |
| `games-util/pyfa` | ✅ | ✅ (`pyfa-bin`) | ✅ |
| `net-firewall/gufw` | ✅ | ❌ | source only |
| `net-firewall/portmaster` | ❌ | ❌ (already binary) | single package |
| `net-vpn/pvpn` | ✅ | ✅ (`pvpn-bin`) | ✅ |
| `sys-power/wattseal` | ✅ | ✅ (`wattseal-bin`) | ✅ |

- `desktop-plus-bin` and `opencode-desktop-bin` are bin-only because their
  upstream source builds rely on Electron/yarn, and `jeveassets-bin` because it
  is built with Maven; none of those source builds are packaged here.
- `gufw` has no upstream binary release, so there is no `gufw-bin`.
- `portmaster` is already a binary launcher package; it downloads its
  components at runtime, so a separate `-bin` variant would duplicate it.
- `clamui`, `pvpn`, `pyfa`, and `wattseal` ship both source and binary variants.
- `lazydocker` is maintained by jordan in GURU and mirrored here from upstream.

`main` contains all custom packages; `upstream` tracks `gentoo/guru` master
and is pull-only. Commits are one package per commit.

## Using this overlay

With `eselect-repository` (`enable` only works for Gentoo-hosted
overlays, so third-party overlays use `add`):

```sh
eselect repository add jentoo git https://github.com/sudo-adduser-jordan/jentoo.git
emaint sync -r jentoo
emerge -avq app-antivirus/clamui app-containers/lazydocker net-firewall/gufw net-firewall/portmaster app-misc/desktop-plus-bin dev-util/opencode-desktop-bin net-vpn/pvpn-bin sys-power/wattseal games-util/jeveassets-bin games-util/pyfa
```

Or manually via `/etc/portage/repos.conf/jentoo.conf`:

```ini
[jentoo]
location = /var/db/repos/jentoo
sync-type = git
sync-uri = https://github.com/sudo-adduser-jordan/jentoo.git
auto-sync = yes
```

Then:

```sh
emaint sync -r jentoo
```

## Developing

```sh
pkgcheck scan -- <category>/<package>
pkgdev manifest -- <category>/<package>
```

Branch workflow per `agents.md`: do not push, do not edit the `upstream`
branch (pull only to sync), one packaging commit per package, and `main`
contains all custom packages.
