let pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  buildInputs = [
    pkgs.openscad
    pkgs.imagemagick
  ];
  shellHook = ''
  '';
}
