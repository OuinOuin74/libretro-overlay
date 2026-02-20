# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Commodore Amiga emulator core (PUAE)"
HOMEPAGE="https://github.com/libretro/libretro-uae"
EGIT_REPO_URI="https://github.com/libretro/libretro-uae.git"

S="${WORKDIR}/${P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	virtual/zlib
"
BDEPEND="
	dev-vcs/git
"

src_compile() {
	emake
}

src_install() {
	insinto /usr/lib/libretro
	doins puae_libretro.so
}
