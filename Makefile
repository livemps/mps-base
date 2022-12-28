# --- Bootstrape  -------------------------------------------------------------
.PHONY: default distrotest error all prepare editor aur-config \
		fonts dotfiles snippets distrotest \
		homedir symlinks bash edit archives transport osutils aur min \
		dotfiles.desktop i3-desktop desktop-tools i3-all \
		dev net txt essentials standard texlive desktop full 
default: standard
include Makefile.all
# --- META TARGETS ---i--------------------------------------------------------
essentials: min
standard: min net dev
texlive: standard txt
desktop: standard i3-all 
full: texlive desktop
