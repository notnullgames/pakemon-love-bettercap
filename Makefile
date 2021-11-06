NAME=pakemon

#TODO: build switch with lovepotion

.PHONY: help run clean setup

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## Install dev-dependencies
	pip3 install makelove 

run: ## Run pakemon, locally
	docker-compose up -d && cp src/conf-dev.lua src/conf.lua && love src; docker-compose down

clean: ## Delete all output files
	rm -rf build

web: build/web                      ## Build for the web
linux: build/appimage               ## Build for Linux
mac: build/macos/pakemon-macos.zip ## Build for MacOS
win: build/win64/pakemon-win64.zip ## Build for Windows
deploy: build/web                   ## Deploy to https://pakemon.surge.sh
	npx surge build/web pakemon.surge.sh

build/web:
	cp src/conf-prod.lua src/conf.lua && cd src && makelove lovejs --config ../makelove.toml
	cd build/lovejs && unzip pakemon-lovejs.zip && mv pakemon ../web && cd .. && rm -rf lovejs && cp ../template.html web/index.html 

build/appimage:
	cp src/conf-prod.lua src/conf.lua && cd src && makelove appimage --config ../makelove.toml

build/macos/pakemon-macos.zip:
	cp src/conf-prod.lua src/conf.lua && cd src && makelove macos --config ../makelove.toml

build/win32/pakemon-win32.zip:
	cp src/conf-prod.lua src/conf.lua && cd src && makelove win32 --config ../makelove.toml

build/win64/pakemon-win64.zip:
	cp src/conf-prod.lua src/conf.lua && cd src && makelove win64 --config ../makelove.toml