# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Super Nintendo Entertainment System core"
HOMEPAGE="https://github.com/libretro/snes9x"
EGIT_REPO_URI="https://github.com/libretro/snes9x.git"

S="${WORKDIR}/${P}"

LICENSE="snes9x GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS=""

RDEPEND="
	virtual/zlib
"
BDEPEND="
	dev-vcs/git
"

src_prepare() {
	default
	sed -i 's/-O3//' libretro/Makefile
}

src_compile() {
	emake -C libretro LTO=
}

src_install() {
	insinto /usr/lib/libretro
	doins libretro/snes9x_libretro.so

	insinto /usr/share/licenses/${PN}
	doins LICENSE
}
