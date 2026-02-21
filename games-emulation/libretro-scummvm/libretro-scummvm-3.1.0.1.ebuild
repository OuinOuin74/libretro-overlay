# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

# Commits des submodules tels que définis dans dependencies.mk du tag v3.1.0.1
DEPS_SHA="7e6e34f0319f4c7448d72f0e949e76265ccf55a1"
COMMON_SHA="70ed90c42ddea828f53dd1b984c6443ddb39dbd6"

DESCRIPTION="ScummVM libretro core"
HOMEPAGE="https://github.com/libretro/scummvm"

SRC_URI="
	https://github.com/libretro/scummvm/archive/refs/tags/libretro-v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/libretro/libretro-deps/archive/${DEPS_SHA}.tar.gz
		-> ${PN}-${PV}-libretro-deps.tar.gz
	https://github.com/libretro/libretro-common/archive/${COMMON_SHA}.tar.gz
		-> ${PN}-${PV}-libretro-common.tar.gz
"
S="${WORKDIR}/scummvm-libretro-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cloud"

# Le Makefile détecte les libs système via sharedlib_test.mk si USE_SYSTEM_<lib>=1
RDEPEND="
	dev-libs/fribidi
	media-libs/faad2
	media-libs/flac
	media-libs/freetype
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libmad
	media-libs/libmpeg2
	media-libs/libpng
	media-libs/libtheora
	media-libs/libvorbis
	media-sound/fluidsynth
	virtual/zlib
	cloud? ( net-misc/curl )
"
BDEPEND="
	app-arch/unzip
	app-arch/zip
"
src_unpack() {
	default

	# Placer les submodules là où le Makefile les attend : backends/platform/libretro/deps/
	local deps_dir="${S}/backends/platform/libretro/deps"
	mkdir -p "${deps_dir}" || die
	mv "${WORKDIR}/libretro-deps-${DEPS_SHA}"     "${deps_dir}/libretro-deps"   || die
	mv "${WORKDIR}/libretro-common-${COMMON_SHA}" "${deps_dir}/libretro-common" || die
}

src_prepare() {
	default

	sed -i \
		-e '/^submodule_test/c\submodule_test = ' \
		-e '/^SUBMODULE_FAILED/c\SUBMODULE_FAILED := ' \
		backends/platform/libretro/dependencies.mk || die

	# Supprime l'écran de démarrage ScummVM affiché au lancement du core
	sed -i 's/splashScreen();/\/\/ splashScreen();/' engines/engine.cpp || die
}

src_compile() {
	# platform=unix et TARGET_64BIT=1 : évite l'auto-détection du Makefile
	# USE_SYSTEM_* : force l'utilisation des libs système via sharedlib_test.mk
	# USE_GIF=1 : active le support GIF (non activé par défaut dans le Makefile)
	emake -C backends/platform/libretro \
		platform=unix \
		TARGET_64BIT=1 \
		CFLAGS="${CFLAGS} -fPIC" \
		CXXFLAGS="${CXXFLAGS} -fPIC" \
		USE_GIF=1 \
		USE_SYSTEM_fluidsynth=1 \
		USE_SYSTEM_FLAC=1 \
		USE_SYSTEM_vorbis=1 \
		USE_SYSTEM_z=1 \
		USE_SYSTEM_mad=1 \
		USE_SYSTEM_faad=1 \
		USE_SYSTEM_png=1 \
		USE_SYSTEM_jpeg=1 \
		USE_SYSTEM_theora=1 \
		USE_SYSTEM_freetype=1 \
		USE_SYSTEM_fribidi=1 \
		USE_SYSTEM_mpeg2=1 \
		USE_SYSTEM_gif=1 \
		USE_CLOUD=1 \
		all
}

src_install() {
	insinto /usr/lib/libretro
	doins backends/platform/libretro/scummvm_libretro.so

	# Installe les datafiles nécessaires au fonctionnement du core
	# (thèmes GUI, ressources pour certains jeux, clavier virtuel...)
	local datadir="${WORKDIR}/scummvm-data"
	mkdir -p "${datadir}" || die
	unzip -q backends/platform/libretro/scummvm.zip -d "${datadir}" || die

	exeinto /usr/lib/libretro
	doexe backends/platform/libretro/scummvm_libretro.so
}
