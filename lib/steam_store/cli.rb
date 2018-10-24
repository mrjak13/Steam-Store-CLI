
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
    create_games

    # game_info(0)
    menu

  end

  def create_games
    SteamStore::Scraper.new.scrape_for_content.each {|game|
      SteamStore::Game.new(game)}
  end

  def menu
    SteamStore::Game.all.pop
    input = nil
    until input == "exit"
      puts "Which game would you like to know more about? [Enter a number or 'exit']"
      puts ""
      SteamStore::Game.all.each.with_index(1) {|game, index| puts "#{index}. #{game.name}"}
      input = gets.strip

      game = SteamStore::Game.all[input.to_i-1]
      game_info(game)
      print_game(game)

      puts ""
      puts "Would you like to know about a different game? [y/n]"
      input = gets.strip.downcase

      if input == "y"
        menu
      elsif input == "n"
        puts "See ya!"
        exit
      else
        menu
      end
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
    puts "It is currently #{game.sale} for #{game.price}"
    puts ""
    puts "About: #{game.summary}"
    puts ""
    puts "Category: #{game.category}"
    puts "For more information please visit #{game.url}"
  end
end
