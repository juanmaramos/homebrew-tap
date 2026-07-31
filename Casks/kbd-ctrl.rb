cask "kbd-ctrl" do
  version "0.1.2"
  sha256 "1b31b8ce58276ac39104ecfbb48d505138a78574bef8ab50317d119e9c9ae1ea"

  url "https://github.com/juanmaramos/kbd.ctrl/releases/download/v#{version}/kbd.ctrl_#{version}_universal.dmg"
  name "kbd.ctrl"
  desc "Configure a three-key macropad for Codex"
  homepage "https://github.com/juanmaramos/kbd.ctrl"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

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
