
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
    start
  end

  def start
    puts "What would you like to see?"
    puts ""
    puts "New Releases ---- Top Selling ---- Coming Soon"#---- On Sale"
    input = gets.strip
    create_games(input)
    SteamStore::Game.all.pop
    menu
  end

  def create_games(input)
    if input.downcase.split.join == "newreleases"
      SteamStore::Scraper.new.new_games.each {|game|
        SteamStore::Game.new(game)}
    elsif input.downcase.split.join == "topselling"
    SteamStore::Scraper.new.top_selling_games.each {|game|
      SteamStore::Game.new(game)}
      SteamStore::Game.all.pop
    elsif input.downcase.split.join == "comingsoon"
      SteamStore::Scraper.new.games_coming_soon.each {|game|
        SteamStore::Game.new(game)}

# ----------- MOST GAMES COMING FROM games_on_sale
# COME UP WITH MISSING INFORMATION WHEN THEY HIT scrape_game----REMOVED FOR NOW

    # elsif input.downcase.split.join == "onsale"
    #   SteamStore::Scraper.new.games_on_sale.each {|game|
    #     SteamStore::Game.new(game)}
    else
      start
    end
  end

  def menu
    input = nil
    puts "Which game would you like to know more about? [Enter a number or exit]"
    puts ""
    SteamStore::Game.all.each.with_index(1) {|game, index| puts "#{index}. #{game.name}"}
    input = gets.strip
    if input != "exit" && input.to_i > 0
      game = SteamStore::Game.all[input.to_i-1]
      game_info(game)
      print_game(game)
      puts ""
      puts "Would you like to know about a different game? [y/n]"
      input = gets.strip.downcase
      if input == "y"
        SteamStore::Game.destroy
        start
      elsif input == "n"
        good_bye
      else
        menu
      end
    else
      good_bye
    end
  end

  def game_info(game)
    game.add_info(SteamStore::Scraper.scrape_game(game.url))
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
    puts "Category: #{game.category}"
    puts "For more information please visit #{game.url}"
  end

  def good_bye
    a = ["Goodbye!", "See ya!", "Later!", "Bye!", "Thank you!", "Till next time!", "You'll be back!"]
    puts ""
    puts "#{a.sample}"
  end
end
