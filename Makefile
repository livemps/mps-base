# --- Bootstrape  -------------------------------------------------------------
.PHONY: default distrotest error all prepare editor aur-config \
		fonts dotfiles snippets distrotest \
		homedir symlinks bash edit archives transport osutils aur min \
		dev net txt essentials standard full 
default: standard
include Makefile.all
# --- Vim Plugins --------------------------------------------------------------
$(VIMPLUG):
	-curl -fLo $(VIMPLUG) --create-dirs $(VIMPLUG_URL)
$(NVIMPLUG):
	-mkdir ~/.config/nvim
	-curl -fLo $(NVIMPLUG) --create-dirs $(VIMPLUG_URL)
# --- Fonts Download ------------------------------------------------------------
./fonts/Awesome/Font\ Awesome\ 6\ Free-Regular-400.otf:
	-mkdir -p ./fonts
	wget $(FONTS_URL_AWESOME) -O ./fonts/Awesome.zip
	unzip ./fonts/Awesome.zip -d ./fonts/Awesome/
	cp ./fonts/Awesome/fontawesome-free-6.2.1-desktop/otfs/*.otf ./fonts/Awesome/
	rm -rf ./fonts/Awesome.zip 
	rm -rf ./fonts/Awesome/fontawesome-free-6.2.1-desktop/
./fonts/Monoid/Monoid\ Bold\ Nerd\ Font\ Complete\ Mono.ttf:
	-mkdir -p ./fonts
	wget $(FONTS_URL_MONOID) -O ./fonts/Monoid.zip
	unzip ./fonts/Monoid.zip -d ./fonts/Monoid
	rm -rf ./fonts/Monoid.zip
./fonts/JetBrainsMono/JetBrains\ Mono\ Regular\ Nerd\ Font\ Complete.ttf:
	-mkdir -p ./fonts
	wget $(FONTS_URL_JETBRAINS)  -O ./fonts/JetBrainsMono.zip
	unzip ./fonts/JetBrainsMono.zip -d ./fonts/JetBrainsMono
	rm -rf ./fonts/JetBrainsMono.zip
# --- Fonts Targets ------------------------------------------------------------
fonts-awesome: ./fonts/Awesome/Font\ Awesome\ 6\ Free-Regular-400.otf
fonts-nerd: ./fonts/Monoid/Monoid\ Bold\ Nerd\ Font\ Complete\ Mono.ttf \
			./fonts/JetBrainsMono/JetBrains\ Mono\ Regular\ Nerd\ Font\ Complete.ttf
fonts: prepare fonts-awesome fonts-nerd
	-mkdir -p ~/.local/share/fonts
	cp -r fonts/* ~/.local/share/fonts
	fc-cache -f -v
# --- HOME folder -------------------------------------------------------------
dotfiles: prepare
	cp -rT dotfiles/ ~
$(MPS_ROOT)/snippets: prepare
	mkdir -p $(MPS_ROOT)/snippets
	cp snippets/* $(MPS_ROOT)/snippets/
	chmod a+x $(MPS_ROOT)/snippets/*
~/.ssh/id_rsa.pub: 
	ssh-keygen
$(MPS_ROOT): fonts dotfiles snippets ~/.ssh/id_rsa.pub prepare
	@for mpsdir in $(FOLDERS) ; do \
		mkdir -p $(MPS_ROOT)/$$mpsdir ; \
	done ;
symlinks: homedir prepare
	@if [ ! "$(SYMLINKS)" == "" ] ; then \
		cd $(MPS_ROOT)/disks/ ; \
		for drives in $(SYMLINKS) ; do \
			rm $(MPS_ROOT)/disks/$$drives ; \
			ln -s $(MPS_ROOT_DISKS)/$$drives ; \
		done ; \
		cd - ; \
	fi
homedir: $(MPS_ROOT) ~/.ssh/id_rsa.pub $(MPS_ROOT)/snippets dotfiles fonts prepare
# --- META TARGETS ---i--------------------------------------------------------
essentials: min
standard: min net dev
full: standard txt
