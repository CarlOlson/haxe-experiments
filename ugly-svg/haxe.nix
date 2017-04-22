with import <nixpkgs> {};

let
  inherit (pkgs)
    stdenv fetchgit ocaml zlib neko pcre;
  inherit (pkgs.ocamlPackages) camlp4;
in

stdenv.mkDerivation {
  name = "haxe-3.4.2";

  buildInputs = [ocaml zlib neko camlp4 pcre];

  src = fetchgit {
    url = "https://github.com/HaxeFoundation/haxe.git";
    sha256 = "1m5fp183agqv8h3ynhxw4kndkpq2d6arysmirv3zl3vz5crmpwqd";
    fetchSubmodules = true;

    # Tag 3.4.2
    rev = "890f8c70cf23ce6f9fe0fdd0ee514a9699433ca7";
  };

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' src/main.ml
  '';

  buildFlags = [ "all" "tools" ];

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe haxelib
    cp -vr std "$out/lib/haxe"
  '';

  dontStrip = true;
}
