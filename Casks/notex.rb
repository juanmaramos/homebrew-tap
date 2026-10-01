cask "notex" do
  version "0.2.8"
  sha256 "a0da1463a5f5072ab19b463eb63933d691a4c12009c73f7d96ec6a0acf7e8fc8"

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
