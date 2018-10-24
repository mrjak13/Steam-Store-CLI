
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
    # binding.pry
    game_info(0)
    # menu

  end

  def create_games
    SteamStore::Scraper.new.scrape_for_content.each {|game|
      SteamStore::Game.new(game)}
  end

  def menu
    puts "Which game would you like to know more about?"
    SteamStore::Game.all.pop
    SteamStore::Game.all.each.with_index(1) {|game, index| puts "#{index}. #{game.name}"}
    input = nil
    until input == "exit"
      input = gets.chomp
    end
  end

  def game_info(index)
    url = SteamStore::Game.all[index.to_i].url
    SteamStore::Game.all[index.to_i].add_info(SteamStore::Scraper.scrape_game(url))
  end
end
