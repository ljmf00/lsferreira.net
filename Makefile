build: build-static build-hugo postscript-build
full-build: clean build
serve: build-static serve-hugo

clean:
	rm -rf public/

build-static:
	./static/generate.sh

gen-lastupdate:
	@echo "Update lastupdate file"
	@sh -c "echo \"<!DOCTYPE html><html lang=\\\"en\\\"><body><pre style=\\\"font-size: xx-small\\\">Last update: \$$(date +%s)</pre></body></html>\" > static/lastupdate.html"

build-hugo: gen-lastupdate
build-hugo:
	hugo $(HUGO_ARGS)

postscript-build:
	./scripts/ignore-files.sh
	./scripts/generate-git.sh

serve-hugo: gen-lastupdate
serve-hugo:
	hugo server $(HUGO_ARGS)

publish-ipfs: build ipfs-pin-public

ipfs-pin-public:
	ipfs add --nocopy --fscache --raw-leaves --pin -r public/

pack-car: build npx-ipfs-car-public

npx-ipfs-car-public:
	npx ipfs-car --pack public/ --output public.car
	npx ipfs-car --list-roots public.car > public.car.cid
