class SteamStore::Scraper

  def home_page
    Nokogiri::HTML(open("https://store.steampowered.com/"))
  end

  def scrape_for_content
    new_releases = home_page.search("#tab_newreleases_content a")
    new_releases.collect {|game| h = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value}}
  end

  def self.scrape_game(url)
    game = Nokogiri::HTML(open(url))
    h={}
    h[:summary] = game.search(".game_description_snippet").text.strip
    h[:release_date] = game.search(".date").text
    h[:developer] = game.search("#developers_list").text.strip
    h[:category] = game.search(".blockbg a:nth-of-type(2)").text
    if game.search(".price").text == ""
      h[:price] = game.search(".discount_final_price").first.text
      h[:sale] = "on sale"
    else
      h[:price] = game.search(".price").first.text.strip
      h[:sale] = "full price"
    end
    h
  end
end
