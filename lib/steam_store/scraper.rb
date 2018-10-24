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

  def self.scrape_game(url)
    game = Nokogiri::HTML(open(url))
    h={}
    h[:summary] = game.search(".game_description_snippet").text.strip
    h[:release_date] = game.search(".date").text
    h[:developer] = game.search("#developers_list").text.strip
    h[:category] = game.search(".blockbg a:nth-of-type(2)").text
    if game.search(".price").text == ""
      h[:price] = game.search(".discount_final_price").first.text
      h[:sale] = "On sale!"
    else
      h[:price] = game.search(".price").text.strip
      h[:sale] = "Full Price"
    end
    h
  end
end
