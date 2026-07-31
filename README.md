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

## About Keylight

Keylight is the licensing layer for desktop apps. You keep your own Stripe account,
your own pricing, and your own customers — Keylight issues the licenses and tells your
app who is allowed to run it. The `keylight` CLI packaged by this tap is how you manage
all of that from a terminal instead of the dashboard.

- **License keys** issued automatically when a payment completes
- **Device activations** with limits you set, and self-serve deactivation
- **Offline validation** — signed Ed25519 leases your app verifies locally
- **Feature entitlements** signed into the lease, so tiers work offline too

[keylight.dev](https://keylight.dev) · [Documentation](https://docs.keylight.dev) · [Pricing](https://keylight.dev/pricing)

### Further reading

- [Manage Your App Licensing From the Terminal](https://keylight.dev/blog/manage-licensing-from-terminal)
