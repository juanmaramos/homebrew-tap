cask "notex" do
  version "0.2.6"
  sha256 "32b7b788cca308ab0fb452c8ea7e00f19d1c63680efc2a4ede3b8dd4ee2482a7"

  url "https://github.com/juanmaramos/notex-releases/releases/download/v#{version}/Notex.dmg",
      verified: "github.com/juanmaramos/notex-releases/"
  name "Notex"
  desc "Native notes, meeting transcription, and summaries"
  homepage "https://notex-swart.vercel.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :tahoe

  app "Notex.app"
end
