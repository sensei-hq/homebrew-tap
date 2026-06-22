# Homebrew cask for the Sensei desktop app (.app bundle).
# Depends on the sensei formula for CLI tools (senseid, sensei-mcp).
#
# Usage:
#   brew tap sensei-hq/tap
#   brew install --cask sensei-hq/tap/senseihq

cask "senseihq" do
  version "0.2.22"

  # Universal binary — runs natively on both Apple Silicon and Intel
  url "https://github.com/sensei-hq/sensei/releases/download/v#{version}/Sensei_#{version}_universal.dmg"
  sha256 "b2dead9e47e6611708a4e62193f0f73cb50f88f4208a7bd339bc76f078549c11"

  name "Sensei"
  desc "AI development intelligence desktop app"
  homepage "https://github.com/sensei-hq/sensei"

  depends_on formula: "sensei"

  app "Sensei.app"

  zap trash: [
    "~/.sensei",
    "~/Library/Application Support/com.senseihq.desktop",
    "~/Library/Caches/com.senseihq.desktop",
    "~/Library/Logs/com.senseihq.desktop",
    "~/Library/Preferences/com.senseihq.desktop.plist",
    "~/Library/Saved Application State/com.senseihq.desktop.savedState",
  ]
end
