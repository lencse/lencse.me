BIN=node_modules/.bin
PRETTIER=$(BIN)/prettier
TSC=$(BIN)/tsc
ASTRO=$(BIN)/astro
TSNODE=$(BIN)/ts-node -r alias-hq/init
URL_DATA_FILE=src/data/urls.json
REDIRECTS_FILE=out/_redirects
QR=public/img/qr

default: dist

dist: node_modules
	$(ASTRO) build
	$(BIN)/jampack ./dist

node_modules: package.json yarn.lock
	yarn --frozen-lockfile
	touch node_modules

format-code: node_modules
	$(PRETTIER) --plugin-search-dir=. --write .

lint: node_modules
	$(PRETTIER) --plugin-search-dir=. --check .
	$(BIN)/eslint .

verify: lint check-types

check-types: node_modules
	$(ASTRO) sync
	$(TSC) -p . --noEmit

dev: node_modules
	$(ASTRO) dev --port 4100
