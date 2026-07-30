cask "kbd-ctrl" do
  version "0.1.0"
  sha256 "2eb41e89cf56e9a875ae7eb8d02486cfac71fe9ea87b8b9e03d1575a3daacb73"

  url "https://github.com/juanmaramos/kbd.ctrl/releases/download/v#{version}/kbd.ctrl_#{version}_universal.dmg"
  name "kbd.ctrl"
  desc "Configure a three-key macropad for Codex"
  homepage "https://github.com/juanmaramos/kbd.ctrl"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :high_sierra

  app "kbd.ctrl.app"

  zap trash: [
    "~/Library/Application Support/com.rhams.kbdctrl",
    "~/Library/LaunchAgents/com.rhams.kbdctrl.plist",
    "~/Library/Logs/com.rhams.kbdctrl",
  ]

  caveats <<~EOS
    kbd.ctrl needs Input Monitoring and Accessibility access.
    The app's guided setup opens the corresponding macOS settings.
  EOS
end
