cask "notex" do
  version "0.2.0"
  sha256 "6d0812bceaa2822ca7f24ada749c4f8605f9a3a8419042ae01b190a667baff9b"

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
