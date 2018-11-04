
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
    SteamStore::Scraper.new.home_page
    start
  end

  def start
    puts "What would you like to see?"
    puts
    SteamStore::Category.all.each {|category| puts "#{category.name.upcase}"}
    puts ""
    puts "Enter a category or exit"
    input = ""
    input = gets.strip

    if SteamStore::Category.find_by_name(input.downcase.split.join) != nil
      menu(input)
    elsif input.downcase.split.join == "exit"
      good_bye
    else
      invalid
      start
    end
  end

  def menu(input)
    input = input.downcase.split.join
    puts ""
    category = SteamStore::Game.find_by_game_category(input)
    category.each.with_index(1) {|game, index| puts "#{index}. #{game.name}"}

    puts ""
    puts "Which game would you like to know more about? [Enter a number]"
    puts ""
    game_number = gets.strip

    if game_number.to_i.between?(1, category.count)
      game = category[game_number.to_i-1]
      game_info(game)

      puts ""
      puts "Would you like to know about a different game? [y/n]"
      answer = gets.strip.downcase

      if answer == "y"
        start
      elsif answer == "n"
        good_bye
      else
        invalid
        start
      end
    else
      invalid
      menu(input)
    end
  end

  def game_info(game)
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

  def invalid
    puts ""
    puts "I didn't understand that"
    puts ""
  end

  def good_bye
    a = ["Goodbye!", "See ya!", "Later!", "Bye!", "Thank you!", "Till next time!", "You'll be back!"]
    puts ""
    puts "#{a.sample}"
    puts ""
    exit
  end

end
