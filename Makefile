.PHONY: build test clean run

build: webapp/dist/index.js webapp/dist/index.html
	stack build

webapp/dist/index.js: webapp/src/Main.purs webapp/packages.dhall webapp/spago.dhall
	cd webapp && spago bundle-app --to dist/index.js

test: webapp/dist/index.js webapp/dist/index.html
	cd webapp && spago test
	stack test

clean:
	rm -f webapp/dist/index.js

run:
	stack exec serendipity-exe
