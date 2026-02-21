# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

inherit git-r3

DESCRIPTION="Nintendo 64 libretro core (Mupen64Plus Next)"
HOMEPAGE="https://github.com/libretro/mupen64plus-libretro-nx"
EGIT_REPO_URI="https://github.com/libretro/mupen64plus-libretro-nx.git"
EGIT_SUBMODULES=('*')

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libpng
	virtual/minizip
	dev-libs/xxhash
	virtual/opengl
	virtual/zlib
"

BDEPEND="
	dev-lang/nasm
"

src_prepare() {
	default

	# Remove hardcoded optimization flags
	sed -i 's/-O[0123s]//;s/-Ofast//' Makefile

	# Fix missing cstdint include (needed with newer GCC/libstdc++)
	sed -i '3a #include <cstdint>' GLideN64/src/GLideNHQ/TxHiResLoader.h
}

src_compile() {
	emake \
		HAVE_PARALLEL_RDP=1 \
		HAVE_PARALLEL_RSP=1 \
		HAVE_THR_AL=1 \
		LLE=1 \
		LTO= \
		SYSTEM_LIBPNG=1 \
		SYSTEM_MINIZIP=1 \
		SYSTEM_XXHASH=1 \
		SYSTEM_ZLIB=1 \
		ARCH=x86_64 \
		WITH_DYNAREC=x86_64
}

src_install() {
	insinto /usr/lib/libretro
	doins mupen64plus_next_libretro.so
}
