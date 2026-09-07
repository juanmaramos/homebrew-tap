cask "notex" do
  version "0.2.2"
  sha256 "21af5bd963ef885285fbb30aa52224ae5f0f2dde804f89089524f15c5c55c4ec"

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
