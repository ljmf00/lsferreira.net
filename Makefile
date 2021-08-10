build: build-static build-hugo postscript-build
serve: build-static serve-hugo

build-static:
	git submodule update --init --recursive
	./static/generate.sh

build-hugo:
	hugo

postscript-build:
	./scripts/ignore-files.sh

serve-hugo:
	hugo server

publish:
	ipfs add --nocopy --fscache --raw-leaves --pin -r public/
