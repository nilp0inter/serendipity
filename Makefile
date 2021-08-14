.PHONY: build test

build:
	cd webapp && spago build
	stack build

test:
	cd webapp && spago test
	stack test
