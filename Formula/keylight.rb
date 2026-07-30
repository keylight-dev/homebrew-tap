class Keylight < Formula
  desc "Manage Keylight apps, licenses, and integrations from the terminal"
  homepage "https://keylight.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/keylight-dev/homebrew-tap/releases/download/keylight-0.1.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d887a21bb89a6cd73104530dd073b343311e5489a3759a7c401f905db5acebec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2e5aa11a2b1284dec93c0d4238cf164c2ceed7eb8647db77be92fbe56951a019"
  end

  # Prebuilt binaries where they are published, source builds everywhere else.
  # The crate is `keylight-cli`; the binary it installs is `keylight`.
  on_macos do
    on_arm do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.0/keylight-aarch64-apple-darwin"
      sha256 "81724895ef6aaa2c443b008bc47f99e0ed85597a898adcaf4ce5851b0dcbef17"
    end

    # No Intel macOS binary is published, so this arch builds from source.
    on_intel do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.1.0.crate"
      sha256 "597a7a084e52caa8af934b81d0aba9175f2c11b9c706f662eaf2598eaa98cde4"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/keylight-dev/keylight-cli/releases/download/v0.1.0/keylight-x86_64-unknown-linux-gnu"
      sha256 "51d69428b51dee4e57c378fef467c398c706711258cb3e92c099c444bdeeec4c"
    end

    on_arm do
      url "https://static.crates.io/crates/keylight-cli/keylight-cli-0.1.0.crate"
      sha256 "597a7a084e52caa8af934b81d0aba9175f2c11b9c706f662eaf2598eaa98cde4"
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
