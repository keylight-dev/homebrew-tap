class Keylight < Formula
  desc "Manage Keylight apps, licenses, and integrations from the terminal"
  homepage "https://keylight.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Prebuilt binaries where they are published, source builds everywhere else.
  # The crate is `keylight-cli`; the binary it installs is `keylight`.
  on_macos do
    on_arm do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.1/keylight-aarch64-apple-darwin"
      sha256 "49380c2103f071bbf20273afb59551e4cff884bb005189e6e1abf30dc07ffda3"
    end

    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.1/keylight-x86_64-apple-darwin"
      sha256 "38c440cbc62c8e312f557448518176be341af4e7e44048fc6fd48aa5b1ad659d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.1/keylight-x86_64-unknown-linux-gnu"
      sha256 "7bf2cd68ffb4475440fdd3a9897b93de8908e0784ecce5546cb057b59a98b045"
    end

    on_arm do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.1.1.crate"
      sha256 "8745077b6fd0478a9c50e46f4327b9cef7b94115dd47228d113e286d446b5216"
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
