# Keylight Homebrew tap

Homebrew formulae for [Keylight](https://keylight.dev) — licensing for desktop apps.

## Install

```bash
brew install keylight-dev/tap/keylight
```

That installs the `keylight` command-line client for the Keylight management API: apps, key
types, licenses, customers, and payment integrations, from the terminal instead of the
dashboard.

```bash
keylight login          # approve in your browser
keylight products list
```

Or tap first, then install:

```bash
brew tap keylight-dev/tap
brew install keylight
```

Or in a `Brewfile`:

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
