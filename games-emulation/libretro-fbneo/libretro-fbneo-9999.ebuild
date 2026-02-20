# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="FinalBurn Neo multi-arcade core"
HOMEPAGE="https://github.com/libretro/FBNeo"
EGIT_REPO_URI="https://github.com/libretro/FBNeo.git"

S="${WORKDIR}/${P}"

LICENSE="FBNeo"
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
	sed -i 's/-O[0123s]//;s/-Ofast//' src/burner/libretro/Makefile
	emake -C src/burner/libretro generate-files
}

src_compile() {
	emake -C src/burner/libretro EXTERNAL_ZLIB=1
}

src_install() {
	insinto /usr/lib/libretro
	doins src/burner/libretro/fbneo_libretro.so

	insinto /usr/share/licenses/${PN}
	doins src/license.txt
}
