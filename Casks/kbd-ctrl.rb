cask "kbd-ctrl" do
  version "0.1.1"
  sha256 "2f43663b9f3f477d1028e49cfa7daf5a44bf315714444fee9b5ea1068ba63f04"

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
