# Homebrew formula for the Sensei CLI.
# Hosted at: https://github.com/sensei-dev/homebrew-tap
# Usage:
#   brew tap sensei-dev/tap
#   brew install sensei-dev/tap/sensei

class Sensei < Formula
  desc "AI development intelligence — CLI for indexing, MCP server, and telemetry"
  homepage "https://github.com/sensei-dev/sensei"
  version "0.1.0"

  # Release archives (produced by `bun run build` + packaging)
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/sensei-dev/sensei/releases/download/v#{version}/sensei-cli-macos-arm64.tar.gz"
    sha256 "REPLACE_WITH_ARM64_SHA256"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/sensei-dev/sensei/releases/download/v#{version}/sensei-cli-macos-x86_64.tar.gz"
    sha256 "REPLACE_WITH_X86_64_SHA256"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/sensei-dev/sensei/releases/download/v#{version}/sensei-cli-linux-arm64.tar.gz"
    sha256 "REPLACE_WITH_LINUX_ARM64_SHA256"
  else
    url "https://github.com/sensei-dev/sensei/releases/download/v#{version}/sensei-cli-linux-x86_64.tar.gz"
    sha256 "REPLACE_WITH_LINUX_X86_64_SHA256"
  end

  bottle :unneeded

  def install
    bin.install "sensei"
    bin.install "senseid"
  end

  def post_install
    # Create ~/.sensei directory for project data
    (Pathname.new(ENV["HOME"]) / ".sensei").mkpath
  end

  # `brew services start sensei` runs the server + graph indexer as a background
  # daemon that starts automatically on login.
  service do
    run [opt_bin/"senseid"]
    keep_alive true
    log_path var/"log/sensei.log"
    error_log_path var/"log/sensei.error.log"
    working_dir ENV["HOME"]
    environment_variables HOME: ENV["HOME"], PATH: "#{HOMEBREW_PREFIX}/bin:/usr/local/bin:/usr/bin:/bin"
  end

  test do
    system "#{bin}/sensei", "--version"
  end
end
