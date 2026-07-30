# Keylight Homebrew tap

Homebrew formulae for [Keylight](https://keylight.dev) — licensing for desktop apps.

## Install

```bash
brew tap keylight-dev/tap
brew trust keylight-dev/tap
brew install keylight
```

That installs the `keylight` command-line client for the Keylight management API: apps, key
types, licenses, customers, and payment integrations, from the terminal instead of the
dashboard.

```bash
keylight login          # approve in your browser
keylight products list
```

The `brew trust` step is not optional and not specific to this tap. Since Homebrew 6, loading a
formula from any third-party tap fails outright until you trust it — it is a supply-chain
control, and it is a good one, because a tap is arbitrary Ruby that runs on your machine. Read
[`Formula/keylight.rb`](Formula/keylight.rb) first if you like; it is 60 lines and downloads a
published release binary. See [Homebrew's docs on tap trust](https://docs.brew.sh/Tap-Trust).

In a `Brewfile`:

```ruby
tap "keylight-dev/tap"
brew "keylight"
```

## Formulae

| Formula | Description | Source |
|---|---|---|
| `keylight` | Keylight management CLI | [keylight-dev/keylight-cli](https://github.com/keylight-dev/keylight-cli) |

## Other install paths

`cargo install keylight-cli` builds from source if you have a Rust toolchain, and every release
publishes prebuilt binaries for macOS, Linux, and Windows on the
[CLI releases page](https://github.com/keylight-dev/keylight-cli/releases).

Issues with the CLI itself belong on
[keylight-cli](https://github.com/keylight-dev/keylight-cli/issues); this repo is only the
packaging.
