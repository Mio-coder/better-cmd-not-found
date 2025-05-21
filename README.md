# better-cmd-not-found

Interactive command-not-found handler for Nix with fuzzy package selection

## Instalation
You can pre-generate database for faster lookup
https://github.com/nix-community/nix-index

Add this repo to inputs
Add this module to nixos:
inputs.better-cmd-not-found.nixosModules.default


## Example
```bash
better-cmd-not-found /nix/store/i48zw14qnz1z9ky9yyw803pr9bxiwhc4-nix-index-0.1.8 clang --help
```
