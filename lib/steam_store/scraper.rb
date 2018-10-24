class SteamStore::Scraper

  def home_page
    Nokogiri::HTML(open("https://store.steampowered.com/"))
  end

  def scrape_for_content
    new_releases = home_page.search("#tab_newreleases_content a")
    # name = new_releases.search(".tab_item_name").text
    # url = new_releases.attribute("href").value
    new_releases.collect {|game| h = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value}}
  end

  def scrape_game(url)
    game = Nokogiri::HTML(open(url))
    h={}
    h[:summary] = game.search(".game_description_snippet").text.strip


  end

end
