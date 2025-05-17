{ pkgs, lib, config, inputs, ... }:

{
  packages = [ ];
  languages.rust.enable = true;
  # processes.cargo-watch.exec = "cargo-watch";
  git-hooks.hooks.clippy.enable = true;
  enterShell = ''
    source ~/.bashrc
  '';
  # See full reference at https://devenv.sh/reference/options/
}
