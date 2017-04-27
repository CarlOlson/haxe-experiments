.PHONY: test
test: haxelib
	haxe test.hxml

haxelib:
	mkdir -p haxelib
	haxelib install utest
	haxelib git monads "https://github.com/carlolson/haxe-monads"

compile:
	haxelib install hxcpp
	haxe -cp src -cp example -lib monads -main Main -cpp bin

clean:
	rm -rf haxelib bin
