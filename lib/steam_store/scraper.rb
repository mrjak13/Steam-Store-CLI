class SteamStore::Scraper

  def home_page
    Nokogiri::HTML(open("https://store.steampowered.com/"))
  end

  def new_games
    new_releases = home_page.search("#tab_newreleases_content a")
    new_releases.collect {|game| h = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value}}
  end

  def top_selling_games
    top_sellers = home_page.search("#tab_topsellers_content a")
    top_sellers.collect {|game| h = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value}}
  end

  def games_coming_soon
    coming_soon = home_page.search("#tab_upcoming_content a")
    coming_soon.collect {|game| h = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value}}
  end

# ----------- MOST GAMES COMING FROM games_on_sale
# COME UP WITH MISSING INFORMATION WHEN THEY HIT scrape_game----REMOVED FOR NOW
  # def games_on_sale
  #   on_sale = home_page.search("#tab_specials_content a")
  #   on_sale.collect {|game| h = {:name => game.search(".tab_item_name").text,
  #     :url => game.attribute("href").value}}
  # end

  def self.scrape_game(url)

    game = Nokogiri::HTML(open(url))
    h={}
    h[:summary] = game.search(".game_description_snippet").text.strip
    if game.search(".date").text == ""
      h[:release_date] = "Coming soon!"
    else
      h[:release_date] = game.search(".date").text
    end
    h[:developer] = game.search("#developers_list").text.strip
    h[:category] = game.search(".blockbg a:nth-of-type(2)").text
    if game.search(".price").text == "" && game.search(".discount_final_price").first != nil
      h[:price] = game.search(".discount_final_price").first.text.strip
      h[:sale] = "on sale"
    elsif game.search(".price").text != ""
      h[:price] = game.search(".price").first.text.strip
      h[:sale] = "full price"
    else
      h[:price] = "coming soon"
      h[:sale] = "not available"
    end
    h
  end
end
