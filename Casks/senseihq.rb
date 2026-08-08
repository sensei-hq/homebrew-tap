# Homebrew cask for the Sensei desktop app (.app bundle).
# Depends on the sensei formula for CLI tools (senseid, sensei-mcp).
#
# Usage:
#   brew tap sensei-hq/tap
#   brew install --cask sensei-hq/tap/senseihq

cask "senseihq" do
  version "0.7.1"

  # Universal binary — runs natively on both Apple Silicon and Intel
  url "https://github.com/sensei-hq/sensei/releases/download/v#{version}/Sensei_#{version}_universal.dmg"
  sha256 "42d00738e865f38d7b72330944f21355432d2f775280e681bbff85420a783441"

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
