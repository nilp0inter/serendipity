{ pkgs ? import <nixpkgs> {} }:

  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ 
      pkgs.stack
      pkgs.purescript
      pkgs.pscid
      pkgs.spago
      pkgs.gnumake
      pkgs.nodejs-14_x
    ];
}
