# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Sega Dreamcast/NAOMI/Atomiswave core"
HOMEPAGE="https://github.com/flyinghead/flycast"
EGIT_REPO_URI="https://github.com/flyinghead/flycast.git"

S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-libs/libglvnd
	virtual/zlib
"
BDEPEND="
	dev-build/cmake
	dev-build/ninja
	dev-util/vulkan-headers
	dev-vcs/git
	media-libs/mesa
"

src_configure() {
	local mycmakeargs=(
		-DLIBRETRO=ON
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
	)
	cmake_src_configure
}

src_install() {
	insinto /usr/lib/libretro
	doins "${BUILD_DIR}/flycast_libretro.so"
}
