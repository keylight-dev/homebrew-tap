class Keylight < Formula
  desc "Manage Keylight apps, licenses, and integrations from the terminal"
  homepage "https://keylight.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/keylight-dev/homebrew-tap/releases/download/keylight-0.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "6bfefeb4366a084049ccc344c71b58f48bf94901f372828768f962c3d5bdc025"
    sha256 cellar: :any_skip_relocation, sequoia:      "0f3cc0dfaaa9e90adb87a05bb2c3e67ddb940ef1e579b9bc4ed608c23ecb871b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cd2d0f16ac1ce33e8872fc71bc42bcc5ebe6dde13ccacbadf2e1c239116fe284"
  end

  # Prebuilt binaries where they are published, source builds everywhere else.
  # The crate is `keylight-cli`; the binary it installs is `keylight`.
  on_macos do
    on_arm do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.2/keylight-aarch64-apple-darwin"
      sha256 "d730803a02dec3e4007efe5608cd4ae26b620a898f56697c7017a1bd8b076ec7"
    end

    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.2/keylight-x86_64-apple-darwin"
      sha256 "4150a259d836fe80a976bf462c4ae683edaf058884e014719d2da0fb2a17ca6e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.2/keylight-x86_64-unknown-linux-gnu"
      sha256 "5085a8aaa6586094bb20d69ca4e71e21aeb3050c13d9ccea95e8d9cb7d97e114"
    end

    on_arm do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.1.2.crate"
      sha256 "b0c8e9da7689be81479a2b617b8f01c8305b64f2b4b3071fb8579105591dc84b"
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
