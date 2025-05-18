# better-cmd-not-found

Interactive command-not-found handler for Nix with fuzzy package selection

## Instalation
You can pre-generate database for faster lookup
https://github.com/nix-community/nix-index

### From source

```bash
cargo build --release
cp target/release/better-cmd-not-found ~/.local/bin/
```

Add to .bashrc:
```bash
command_not_found_handle() { ~/.local/bin/better-cmd-not-found "$@"; return $?; }
```
