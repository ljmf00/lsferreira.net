build: build-static build-hugo
serve: build-static serve-hugo

build-static:
	git submodule update --init --recursive
	./static/generate.sh

build-hugo:
	hugo

serve-hugo:
	hugo server

