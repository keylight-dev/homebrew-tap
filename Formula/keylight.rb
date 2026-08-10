class Keylight < Formula
  desc "Manage Keylight apps, licenses, and integrations from the terminal"
  homepage "https://keylight.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/keylight-dev/homebrew-tap/releases/download/keylight-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "05bc7e80326d474348dddfa3871588d3aa429e25ae198bec083d5a3cfc5f5111"
    sha256 cellar: :any_skip_relocation, sequoia:      "c98de8e2ac582174c0ebf48801182c2c6d9685891ec5d68b7cd10825558ec319"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "886caaa8e5107a3934ef860bf137080d0c6801fd60ec777b5656f7d07c06301f"
  end

  # Prebuilt binaries where they are published, source builds everywhere else.
  # The crate is `keylight-cli`; the binary it installs is `keylight`.
  on_macos do
    on_arm do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.2.1/keylight-aarch64-apple-darwin"
      sha256 "3cfea466abe0ce2aeb2f605a6865fa32909238015c39e6593aca1b6e5991da00"
    end

    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.2.1/keylight-x86_64-apple-darwin"
      sha256 "8c68943464dbf03e04f2963f03305ce65ec5e3b034ca8076fead815bc3efd2de"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.2.1/keylight-x86_64-unknown-linux-gnu"
      sha256 "31d0c0286c498693a9de51b133b174c5b13e602b003cfd4889ac2446414416b6"
    end

    on_arm do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.2.1.crate"
      sha256 "6e1119b5b162b90f597471ac408125929d576f92ab3bd4a043495ae1f65bbef3"
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
