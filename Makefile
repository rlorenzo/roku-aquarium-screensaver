# Settings: pass on the command line or put them in local.mk (gitignored).
#   make install VIDEO_URL=http://192.168.1.10/aquarium/aquarium.mp4 ROKU_IP=192.168.1.20 ROKU_PASS=devpassword
-include local.mk
ZIP = out/aquarium.zip

zip:
	@test -n "$(VIDEO_URL)" || (echo "Set VIDEO_URL (see README)"; exit 1)
	rm -rf out && mkdir -p out/build
	cp -R manifest source components images out/build/
	rm -f out/build/images/icon_source.png
	sed -i.bak 's#"VIDEO_URL"#"$(VIDEO_URL)"#' out/build/components/Screensaver.xml && rm out/build/components/*.bak
	cd out/build && zip -qr ../aquarium.zip . -x '.*'

install: zip
	@test -n "$(ROKU_IP)" -a -n "$(ROKU_PASS)" || (echo "Set ROKU_IP and ROKU_PASS"; exit 1)
	curl -sS --user rokudev:$(ROKU_PASS) --digest -F mysubmit=Install -F archive=@$(ZIP) http://$(ROKU_IP)/plugin_install | grep -o 'Install Success\|Identical to previous version\|Install Failure[^<]*'

.PHONY: zip install
