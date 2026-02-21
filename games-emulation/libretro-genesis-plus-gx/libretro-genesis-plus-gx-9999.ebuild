# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

inherit git-r3

DESCRIPTION="Sega 8/16 bit libretro core (MS/GG/MD/CD) - Genesis Plus GX"
HOMEPAGE="https://github.com/libretro/Genesis-Plus-GX"
EGIT_REPO_URI="https://github.com/libretro/Genesis-Plus-GX.git"

LICENSE="Genesis-Plus-GX"
SLOT="0"
KEYWORDS=""

src_prepare() {
	default
	sed -i 's/-O[0123s]//;s/-Ofast//' Makefile.libretro
}

src_compile() {
	emake -f Makefile.libretro
}

src_install() {
	insinto /usr/lib/libretro
	doins genesis_plus_gx_libretro.so
}
