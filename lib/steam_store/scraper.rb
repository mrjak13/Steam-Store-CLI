class SteamStore::Scraper

  def home_page
    puts "******Scraping home page*****"
    doc = Nokogiri::HTML(open("https://store.steampowered.com/"))
    new_releases = doc.search("#tab_newreleases_content a")
    top_sellers = doc.search("#tab_topsellers_content a")
    coming_soon = doc.search("#tab_upcoming_content a")
    on_sale = doc.search("#tab_specials_content a")

    master_array = []
    new_releases.each do |game| game_hash = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value, :category => ["newreleases"]}
      master_array << game_hash
    end

    top_sellers.each do |game| game_hash = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value, :category => ["topselling"]}
      master_array << game_hash
    end

    coming_soon.each do |game| game_hash = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value, :category => ["comingsoon"]}
      master_array << game_hash
    end

    on_sale.each do |game| game_hash = {:name => game.search(".tab_item_name").text,
      :url => game.attribute("href").value, :category => ["onsale"]}
      master_array << game_hash
    end
    master_array
  end

  def self.scrape_game(url)
    puts  "**********Scrape Game**********"
    game = Nokogiri::HTML(open(url))
    game_details={}
    game_details[:summary] = game.search(".game_description_snippet").text.strip
    if game.search(".date").text == ""
      game_details[:release_date] = "Coming soon!"
    else
      game_details[:release_date] = game.search(".date").text
    end
    game_details[:developer] = game.search("#developers_list").text.strip
    game_details[:game_type] = game.search(".blockbg a:nth-of-type(2)").text
    if game.search(".price").text == "" && game.search(".discount_final_price").first != nil
      game_details[:price] = game.search(".discount_final_price").first.text.strip
      game_details[:sale] = "on sale"
    elsif game.search(".price").text != ""
      game_details[:price] = game.search(".price").first.text.strip
      game_details[:sale] = "full price"
    else
      game_details[:price] = "coming soon"
      game_details[:sale] = "not available"
    end
    game_details
  end
end
