# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

inherit git-r3

DESCRIPTION="Sony PlayStation libretro core (Beetle PSX)"
HOMEPAGE="https://github.com/libretro/beetle-psx-libretro"
EGIT_REPO_URI="https://github.com/libretro/beetle-psx-libretro.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hw"

RDEPEND="
	hw? (
		virtual/opengl
		media-libs/vulkan-loader
	)
"

BDEPEND="
	hw? ( media-libs/mesa )
"

src_prepare() {
	default
	sed -i 's/-O[0123s]//;s/-Ofast//' Makefile
}

src_compile() {
	if use hw; then
		emake HAVE_HW=1
	else
		emake
	fi
}

src_install() {
	insinto /usr/lib/libretro
	if use hw; then
		doins mednafen_psx_hw_libretro.so
	else
		doins mednafen_psx_libretro.so
	fi
}
