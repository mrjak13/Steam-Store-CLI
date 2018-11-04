class SteamStore::Category
  # extend SteamStore::Findable

  attr_accessor :name, :games

  @@all =[]

  def initialize(name)
    @name = name
    @games = []
    @@all << self
  end

  def self.find_by_name(name)
    all.find {|category| category.name == name}
  end

  # def self.find_games_with_cat(cat)
  #   all.each do |category|
  # -----MAYBE USE FIND BELOW---
  #     category.games.select do |game|
  #       game.category.each{|cat_name| cat_name = cat}
  #     end
  #   end
  # end

  def self.all
    @@all
  end

end
