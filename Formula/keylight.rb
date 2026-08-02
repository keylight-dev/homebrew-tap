class Keylight < Formula
  desc "Manage Keylight apps, licenses, and integrations from the terminal"
  homepage "https://keylight.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/keylight-dev/homebrew-tap/releases/download/keylight-0.1.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "6243f56287f1867b99b81f15dfc324de15039382d3a52f32cee5cd7fc4dfad9f"
    sha256 cellar: :any_skip_relocation, sequoia:      "760f92bd7bbe04d18b203b8fb5b53e0ea1511a047be4666a7933f1bfa2b44538"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "825484601465b7841698b290a8d9612a36903c6066bf93cc5022873a7ec53430"
  end

  # Prebuilt binaries where they are published, source builds everywhere else.
  # The crate is `keylight-cli`; the binary it installs is `keylight`.
  on_macos do
    on_arm do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.3/keylight-aarch64-apple-darwin"
      sha256 "e3819dbfd80021f20054de63dc4c61b63b266342c032fd64e43e24dee34a08cf"
    end

    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.3/keylight-x86_64-apple-darwin"
      sha256 "5388503feb286b78047bff893322770e5885e5df6c3e111d30cb92a099d20577"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.3/keylight-x86_64-unknown-linux-gnu"
      sha256 "17fe40b76c7dc3f94ae8e00eaaf6993f7a685edced798dc7cb0eb0e7e1f4ae9b"
    end

    on_arm do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.1.3.crate"
      sha256 "4e9cc2a137ad8e5ce7aeb4969e14cb13019eb74c11c9b04a7ec79361d3e7a27b"
      depends_on "rust" => :build
    end
  end

  # Bottles are built by the tap's CI on pull requests and published by
  # `brew pr-pull`. They matter more than usual here: without one, brew takes the
  # build-from-source path, which enforces a minimum Xcode for the running macOS
  # and hard-fails when the installed Xcode is older — an error about Xcode, on a
  # machine that only wanted a licensing CLI.

  def install
    # The source archive has a Cargo.toml; a downloaded release binary does not.
    if File.exist?("Cargo.toml")
      system "cargo", "install", *std_cargo_args
    else
      # A bare binary arrives 0644 from the release asset, so set the mode
      # rather than assuming an archive preserved it.
      bin.install Dir["keylight-*"].first => "keylight"
      chmod 0755, bin/"keylight"
    end
  end

  test do
    assert_match "keylight #{version}", shell_output("#{bin}/keylight --version")
    assert_match "Usage: keylight", shell_output("#{bin}/keylight --help")

    # No command may block on a prompt — that is the property the whole CLI
    # rests on. Unauthenticated, it must exit 2 rather than ask for anything.
    output = shell_output("#{bin}/keylight auth status 2>&1", 2)
    assert_match "no API token configured", output
  end
end
