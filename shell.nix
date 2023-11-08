{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib, stdenv ? pkgs.stdenv, ... }:

let
  ruby = pkgs.ruby_3_2;
  paths = with pkgs; [
    file
    gcc
    git
    gnumake
    libffi
    libpcap
    libxml2
    libxslt
    pkg-config
    ruby
    zlib
  ];

  env = pkgs.buildEnv {
    name = "flat-jobs-env";
    paths = paths;
    extraOutputsToInstall = [ "bin" "lib" "include" ];
  };

  makeCpath = lib.makeSearchPathOutput "include" "include";
  makePathExpression = new:
    builtins.concatStringsSep ":" [ new (builtins.getEnv "PATH") ];
in pkgs.mkShell rec {
  name = "flat-jobs";
  noPhase = ''
    mkdir -p $out/bin
    ln -s ${env}/bin/* $out/bin/
  '';
  buildInputs = paths;
  src = ./.;
  PROJECT_ROOT = toString ./. + "/";
  CPATH = makeCpath [ env ];
  GEM_HOME = PROJECT_ROOT + "/.gem/ruby/${ruby.version}";
  LIBRARY_PATH = lib.makeLibraryPath [ env ];
  PATH = makePathExpression (lib.makeBinPath [ PROJECT_ROOT GEM_HOME env ]);

  shellHook = ''
    unset CC

    export PATH=${PATH}:$PATH
  '';
}
