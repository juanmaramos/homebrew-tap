cask "notex" do
  version "0.2.3"
  sha256 "d3ef43e8b27d65ef4d0275da2daafc89c36f4061acba4557191c43bbf1702359"

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
