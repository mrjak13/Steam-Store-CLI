class SteamStore::Scraper

  def home_page
    doc = Nokogiri::HTML(open("https://store.steampowered.com/"))
    binding.pry
  end

end
