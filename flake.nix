{
  description = "flat-jobs development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ruby = pkgs.ruby_3_2;
        buildInputs = with pkgs; [
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
      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;
          
          shellHook = ''
            export PROJECT_ROOT=$PWD
            export GEM_HOME=$PROJECT_ROOT/.gem/ruby/${ruby.version}
            export PATH=$GEM_HOME/bin:$PATH
            export LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}
            export CPATH=${pkgs.lib.makeSearchPathOutput "include" "include" buildInputs}
          '';
        };
      });
}