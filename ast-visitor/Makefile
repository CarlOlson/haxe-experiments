.PHONY: test
test: haxelib
	haxe test.hxml

haxelib:
	mkdir -p haxelib
	haxelib install utest
	haxelib git monads "https://github.com/carlolson/haxe-monads"

clean:
	rm -rf haxelib
