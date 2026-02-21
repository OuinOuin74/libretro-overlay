# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

inherit git-r3

DESCRIPTION="libretro port of xrick (Rick Dangerous)"
HOMEPAGE="https://github.com/libretro/xrick-libretro"
EGIT_REPO_URI="https://github.com/libretro/xrick-libretro.git"

LICENSE="xrick"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake
}

src_install() {
	insinto /usr/lib/libretro
	doins xrick_libretro.so

	dodoc README
}
