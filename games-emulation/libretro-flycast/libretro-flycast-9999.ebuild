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
	dev-libs/libzip
	dev-util/glslang
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

src_prepare() {
	cmake_src_prepare
	# Remplace le bloc libzip bundlé par un find_package système
	sed -i \
		'/if(NOT LIBZIP_FOUND OR NINTENDO_SWITCH)/,/^endif()/c\find_package(libzip REQUIRED)\ntarget_link_libraries(${PROJECT_NAME} PRIVATE libzip::zip)' \
		CMakeLists.txt
	# Force nowide en statique pour éviter les RPATHs vers le build dir
	sed -i 's/add_library(nowide src/add_library(nowide STATIC src/' \
		core/deps/nowide/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DLIBRETRO=ON
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DUSE_HOST_GLSLANG=ON
		-DUSE_HOST_LIBZIP=ON
	)
	cmake_src_configure
}

src_install() {
	insinto /usr/lib/libretro
	doins "${BUILD_DIR}/flycast_libretro.so"
}
