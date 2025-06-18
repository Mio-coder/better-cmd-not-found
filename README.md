# project archived, pay-respects is much better
# better-cmd-not-found

Interactive command-not-found handler for Nix with fuzzy package selection

You can pre-generate database for faster lookup
https://github.com/nix-community/nix-index

## Instalation

Add this repo to inputs
Add this module to nixos:
inputs.better-cmd-not-found.nixosModules.default

## Example
```bash
better-cmd-not-found clang --help
```

## Similar software
https://github.com/nix-community/comma
https://github.com/iffse/pay-respects
