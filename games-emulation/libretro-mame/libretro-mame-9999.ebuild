# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

PYTHON_COMPAT=( python3_{11,12,13,14} )

inherit git-r3 python-any-r1

DESCRIPTION="MAME libretro core (Arcade)"
HOMEPAGE="https://github.com/libretro/mame"
EGIT_REPO_URI="https://github.com/libretro/mame.git"

LICENSE="MAME"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/alsa-lib
	media-libs/libglvnd
	virtual/zlib
"

BDEPEND="
	${PYTHON_DEPS}
"

src_prepare() {
	default
}

src_compile() {
	unset ARCH
	emake \
		OSD="retro" \
		RETRO=1 \
		NOWERROR=1 \
		OS="linux" \
		TARGETOS="linux" \
		CONFIG="libretro" \
		NO_USE_MIDI="1" \
		PTR64=1 \
		TARGET=mame \
		SUBTARGET=arcade \
		PYTHON_EXECUTABLE="${EPYTHON}"
}

src_install() {
	insinto /usr/lib/libretro
	newins mamearcade_libretro.so mame_libretro.so
}
