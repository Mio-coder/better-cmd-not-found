use anyhow::{Context, Result};
use dialoguer::{FuzzySelect, theme::ColorfulTheme};
use std::env;
use std::process::Command;
use atty;
use console::style;

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <command>", args[0]);
        return Ok(());
    }
    let cmd = &args[1];
    let cmd_args = &args[2..];

    if env::var_os("MC_SID").is_some() || !atty::is(atty::Stream::Stdout) {
        eprintln!("{}: command not found", cmd);
        std::process::exit(127);
    }
    eprintln!("Searching in nixpkgs...");

    let output = Command::new("nix-locate")
        .args(["--minimal", "--no-group", "--type=x", "--type=s", "--top-level", "--whole-name", "--at-root"])
        .arg(format!("/bin/{}", cmd))
        .output()
        .context("Failed to execute nix-locate")?;

    let attrs = String::from_utf8(output.stdout)
        .context("nix-locate output is not valid UTF-8")?;
    let attrs: Vec<&str> = attrs.lines().collect();

    if attrs.is_empty() {
        eprintln!("{}: command not found", cmd);
        std::process::exit(127);
    }

    let selection = FuzzySelect::with_theme(&ColorfulTheme::default())
        .with_prompt(format!(
            "{} Run '{}' using which package? (ESC to cancel)",
            style("?").green(),
            cmd
        ))
        .items(&attrs)
        .default(0)
        .interact_opt()?;

    match selection {
        Some(index) => {
            let selected_attr = attrs[index];
            let status = Command::new("nix-shell")
                .arg("-p")
                .arg(selected_attr)
                .arg("--run")
                .arg(format!("{} {}", cmd, shlex::try_join(cmd_args.iter().map(|s| s.as_str()))?))
                .status()
                .context("Failed to execute nix-shell")?;
            
            std::process::exit(status.code().unwrap_or(127));
        }
        None => {
            eprintln!("{}: command not found", cmd);
            std::process::exit(127);
        }
    }
}
