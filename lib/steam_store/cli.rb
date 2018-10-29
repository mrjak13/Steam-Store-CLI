
class SteamStore::CLI

  def call
    puts <<-DOC
    ██████████████████████████████▀▀▀▀███
    ████████████████████████████▀─▄▀▀▄─▀█
    ██▀─▄▄─▀████████████████████─█────█─█
    █─▄▀──▀─▀███████████████████─▀▄──▄▀─█
    █─█───────▀█████████████████▄──▀▀───█
    █▄─▀▄▄▀─────▀███████████████▀─────▄██
    ███▄▄▄▄█▄─────▀████████████▀─────▄███
    ██████████▄─────▀█████████▀─────▄████
    ████████████▄─────▀██████▀─────▄█████
    ██████████████▄─────▀▀──▀─────▄██████
    ████████████████▄──────▀▀▄───▄███████
    ██████████████████▄───────█─▄████████
    ████████████████████▄─▄──▄▀─█████████
    █████████████████████▄─▀▀─▄██████████
    █████████████████████████████████████
    █░░░░░█░░░░░░█░░░░░███░░░███░░████░░█
    █░░██████░░███░░██████░░░███░░░██░░░█
    █░░░░░███░░███░░░░░██░░█░░██░░░░░░░░█
    ████░░███░░███░░█████░░░░░██░░█░░█░░█
    █░░░░░███░░███░░░░░█░░░█░░░█░░█░░█░░█
    █████████████████████████████████████
    DOC

    puts "Welcome to the Steam Store"
    puts ""
    create_games
    start
  end

  def start
    puts "What would you like to see?"
    puts ""
    puts "New Releases ---- Top Selling ---- Coming Soon"#---- On Sale"
    input = gets.strip
    # create_games
    # SteamStore::Game.all.pop
    if input.downcase.split.join == "newreleases" || "topselling" || "comingsoon"
      menu(input)
    else puts "I didn't understand that"
      start
    end
  end

  def create_games
    # if input.downcase.split.join == "newreleases" || "topselling" || "comingsoon" && SteamStore::Game.find_by_game_type(input) == []
    SteamStore::Scraper.new.home_page.each do |game| if game[:name] != ""
        SteamStore::Game.new(game)
      else nil
      end
    end

    # elsif input.downcase.split.join == "topselling"
    # SteamStore::Scraper.new.top_selling_games.each {|game|
    #   SteamStore::Game.new(game)}
    #   # SteamStore::Game.all.pop
    # elsif input.downcase.split.join == "comingsoon"
    #   SteamStore::Scraper.new.games_coming_soon.each {|game|
    #     SteamStore::Game.new(game)}

# ----------- MOST GAMES COMING FROM games_on_sale
# COME UP WITH MISSING INFORMATION WHEN THEY HIT scrape_game----REMOVED FOR NOW

    # elsif input.downcase.split.join == "onsale"
    #   SteamStore::Scraper.new.games_on_sale.each {|game|
    #     SteamStore::Game.new(game)}
    # else
    #   start
    # end
  end

  def menu(input)
    input = input.downcase.split.join
    # binding.pry
    # puts "Which game would you like to know more about? [Enter a number or exit]"
    puts ""
    SteamStore::Game.find_by_game_type(input).each.with_index(1) {|game, index| puts "#{index}. #{game.name}"}
    puts ""
    puts "Which game would you like to know more about? [Enter a number or exit]"
    puts ""
    game_number = gets.strip
    if game_number != "exit" && game_number.to_i > 0
      game = SteamStore::Game.find_by_game_type(input)[game_number.to_i-1]
      game_info(game)
      print_game(game)
      puts ""
      puts "Would you like to know about a different game? [y/n]"
      answer = gets.strip.downcase
      if answer == "y"
        # SteamStore::Game.destroy
        start
      elsif answer == "n"
        good_bye
      else
      end
    else puts "I did not understand that"
      menu(input)
    end
  end

  def game_info(game)
    binding.pry
    if game.price == nil
      game.add_info(SteamStore::Scraper.scrape_game(game.url))
      print_game(game)
    else
      print_game(game)
    end
  end

  def print_game(game)
    puts ""
    puts "#{game.name}"
    puts ""
    puts "Developed by #{game.developer} and was released on #{game.release_date}."
    puts "It is currently #{game.sale} #{game.price}."
    puts ""
    puts "About: #{game.summary}"
    puts ""
    puts "Category: #{game.game_type}"
    puts "For more information please visit #{game.url}"
  end

  def good_bye
    a = ["Goodbye!", "See ya!", "Later!", "Bye!", "Thank you!", "Till next time!", "You'll be back!"]
    puts ""
    puts "#{a.sample}"
    exit
  end
end
