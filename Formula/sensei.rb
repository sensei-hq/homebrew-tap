# Homebrew formula for the Sensei CLI tools.
# Installs: senseid (daemon), sensei (CLI), sensei-mcp (MCP server)
#
# Two install paths:
#   brew install sensei-hq/tap/sensei          # released artefacts (default)
#   brew install --HEAD sensei-hq/tap/sensei   # build from main branch source
#
# The HEAD path is the fallback when no release has been tagged yet (404 on
# the tarball URL). Build invocation goes through `make crates-release` so
# the formula and `make install-release` share one cargo invocation.

class Sensei < Formula
  desc "AI development intelligence — CLI, daemon, and MCP server"
  homepage "https://github.com/sensei-hq/sensei"
  version "0.19.0"

  # Release archives built by GitHub Actions (release-daemon.yml).
  # Each tarball contains a single directory named after the artifact
  # (e.g. sensei-macos-arm64/) holding senseid, sensei, and sensei-mcp.
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/sensei-hq/sensei/releases/download/v#{version}/sensei-macos-arm64.tar.gz"
    sha256 "bdeb6fec42b3ad8e4fb296227d1c9023df6c2b10f5437b696a34ffe26aabd227"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/sensei-hq/sensei/releases/download/v#{version}/sensei-macos-x86_64.tar.gz"
    sha256 "c15f8dac3051109a8b6695c6f639d5dfe5122e6dffdba75efd989c6039cddc23"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/sensei-hq/sensei/releases/download/v#{version}/sensei-linux-arm64.tar.gz"
    sha256 "59826c736c261454f86f8d060f1dbb1f84768c377c07859abb915451021b1b0b"
  else
    url "https://github.com/sensei-hq/sensei/releases/download/v#{version}/sensei-linux-x86_64.tar.gz"
    sha256 "049c09706ba6906480c8578892866ed152afd3e62e06870210a0687fcca40bce"
  end

  # HEAD path: build from source on `main`.
  # SSH (not HTTPS) so the private sensei-hq/sensei repo can be cloned via
  # the developer's existing GitHub SSH key — HTTPS would prompt for
  # username/password and hang brew bundle.
  # `using: :git` forces the git download strategy — brew only auto-detects
  # git from `.git`-suffixed HTTPS URLs, not from SSH-style URLs.
  head "git@github.com:sensei-hq/sensei.git", branch: "main", using: :git

  # Build-time deps are only consulted on the HEAD branch (source build).
  depends_on "rust" => :build
  depends_on "make" => :build
  # Runtime dep — sensei pins postgresql@17 so dev and prod use the same major.
  depends_on "postgresql@17"

  def install
    if build.head?
      # HEAD path: reuse `make crates-release` so this formula and
      # `make install-release` share one cargo invocation.
      system "make", "crates-release"
      bin.install "target/release/senseid"
      bin.install "target/release/sensei"
      bin.install "target/release/sensei-mcp"
    else
      # Release-tarball path: binaries live inside the platform-specific
      # subdirectory inside the tarball.
      arch_dir = Dir["*/"].first || ""
      bin.install "#{arch_dir}sensei"
      bin.install "#{arch_dir}senseid"
      bin.install "#{arch_dir}sensei-mcp"
    end

    # Adhoc codesign on macOS so the Tauri sidecar can spawn them.
    # (macOS Sequoia Code Signing Monitor at level 2 requires this.)
    if OS.mac?
      %w[senseid sensei sensei-mcp].each do |name|
        system "codesign", "--sign", "-", "--options", "runtime", "--force",
               bin/name
      end
    end
  end

  def post_install
    (Pathname.new(Dir.home) / ".sensei").mkpath
  end

  service do
    run [opt_bin/"senseid"]
    keep_alive true
    log_path var/"log/sensei.log"
    error_log_path var/"log/sensei.error.log"
    working_dir Dir.home
    environment_variables HOME: Dir.home, PATH: "#{HOMEBREW_PREFIX}/bin:/usr/local/bin:/usr/bin:/bin"
  end

  def caveats
    <<~EOS
      Installed sensei binaries (port 7744, db sensei, dir ~/.sensei/).

      Start the daemon:

        brew services start sensei   # managed by launchd, restarts on crash
        # or, for a foreground process:
        sensei start

      Configure sensei for your AI coding platform:

        sensei install --acp claude-code   # or cursor, windsurf
        sensei scan ~/Developer            # scan and index your repos

      Before uninstalling:

        sensei stop
        sensei uninstall

      Note: Homebrew formulas have no uninstall hook, so this step is manual.
    EOS
  end

  test do
    system "#{bin}/sensei", "--version"
  end
end
