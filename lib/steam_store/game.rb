class SteamStore::Game
  attr_accessor :name, :url, :summary, :release_date, :developer, :category, :price, :sale, :game_type

  @@all = []

  def initialize(hash)
    hash.each do |k, v|
      self.send("#{k}=", v)
    end
    SteamStore::Category.find_by_name(category).games << self
    @@all << self
  end

  def self.create_from_collection(array)
    array.each do |hash|
      if hash != 0
        self.new(hash)
      end
    end
  end

  def add_info(hash)
    hash.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def self.all
    @@all
  end

  def self.find_by_name(name)
    all.find {|game| game.name == name}
  end

  def self.find_by_game_type(category)
    all.select {|game| game.category.include? category}
  end

end
