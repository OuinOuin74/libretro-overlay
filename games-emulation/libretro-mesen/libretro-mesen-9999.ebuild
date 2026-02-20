# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Nintendo Entertainment System core"
HOMEPAGE="https://www.mesen.ca/"
EGIT_REPO_URI="https://github.com/libretro/Mesen.git"

S="${WORKDIR}/${P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

BDEPEND="
	dev-vcs/git
"

src_prepare() {
	default
	sed -i 's/-O[0123s]//;s/-Ofast//' Libretro/Makefile
}

src_compile() {
	emake -C Libretro LTO=
}

src_install() {
	insinto /usr/lib/libretro
	doins Libretro/mesen_libretro.so
}
