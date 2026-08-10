class Keylight < Formula
  desc "Manage Keylight apps, licenses, and integrations from the terminal"
  homepage "https://keylight.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/keylight-dev/homebrew-tap/releases/download/keylight-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "8bcb5c604ee13073e1502768169edb9526a713e0b89e04f1aa02d8194335cbfb"
    sha256 cellar: :any_skip_relocation, sequoia:      "c602e8791bfa258aed3d692feabe189b4fa69b5305263e03453726dda6db5b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9bd15bc576f645d9ba604fce4a0bce27a5295d622df9d1c00fae37b73adf04e6"
  end

  # Prebuilt binaries where they are published, source builds everywhere else.
  # The crate is `keylight-cli`; the binary it installs is `keylight`.
  on_macos do
    on_arm do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.2.0/keylight-aarch64-apple-darwin"
      sha256 "99fafc54e964e136fc7870805ef5ef20bdbb6e73f2918f8ee914390e07fc63dd"
    end

    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.2.0/keylight-x86_64-apple-darwin"
      sha256 "1fdc6331629d25a54c4758f5fbab648e64788a47384c42f5104f58caaaaa0902"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.2.0/keylight-x86_64-unknown-linux-gnu"
      sha256 "3b71a0b3b667891b4f984dd3ded39cdb5a810ca02e167876b54760ee346ba163"
    end

    on_arm do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.2.0.crate"
      sha256 "f5fe512014b2690826f3a2eb27dabe1bf1dee16b59f190617abf9f3eff232703"
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
