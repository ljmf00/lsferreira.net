build: build-static build-hugo postscript-build
full-build: clean build
serve: build-static serve-hugo

clean:
	rm -rf public/

build-static:
	git submodule update --init --recursive
	./static/generate.sh

build-hugo:
	hugo

postscript-build:
	./scripts/ignore-files.sh

serve-hugo:
	hugo server

publish-ipfs: build ipfs-pin-public

ipfs-pin-public:
	ipfs add --nocopy --fscache --raw-leaves --pin -r public/

pack-car: build npx-ipfs-car-public

npx-ipfs-car-public:
	npx ipfs-car --pack public/ --output public.car
