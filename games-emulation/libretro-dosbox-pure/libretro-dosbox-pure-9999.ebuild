# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="MS-DOS core"
HOMEPAGE="https://github.com/schellingb/dosbox-pure"
EGIT_REPO_URI="https://github.com/schellingb/dosbox-pure.git"

S="${WORKDIR}/${P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-vcs/git
"

src_prepare() {
	default
	sed -E \
		-e 's/^(\s*(CFLAGS|LDFLAGS)\s*):=/\1+=/' \
		-e 's/-Wno-format//' \
		-e 's/-O[0123s]//;s/-Ofast//' \
		-i Makefile
}

src_compile() {
	emake
}

src_install() {
	insinto /usr/lib/libretro
	doins dosbox_pure_libretro.so
}
