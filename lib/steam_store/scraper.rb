class SteamStore::Scraper

  def home_page
    puts "******Scraping home page*****"
    doc = Nokogiri::HTML(open("https://store.steampowered.com/"))

    sub_sections = %w[newreleases topsellers upcoming specials]

    sub_sections.each do |section|
      SteamStore::Category.new(section)
      scrape_section(doc.search("#tab_#{section}_content a"), section)
    end
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

  def scrape_section(section, section_name)
    section.each do |sec|
      if SteamStore::Game.find_by_name(sec.search(".tab_item_name").text)
        SteamStore::Game.find_by_name(sec.search(".tab_item_name").text).category << SteamStore::Category.find_by_name(section_name)
      else
        game_hash = {
          :name => sec.search(".tab_item_name").text,
          :url => sec.attribute("href").value,
          :category => [SteamStore::Category.find_by_name(section_name)]
        }

        if game_hash.is_a? Hash
          SteamStore::Game.create_from_hash(game_hash)
        end
      end
    end
  end

end
