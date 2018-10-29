class SteamStore::Game
  attr_accessor :name, :url, :summary, :release_date, :developer, :category, :price, :sale, :game_type

  @@all = []

  def initialize(hash)
    hash.each do |k, v|
      self.send("#{k}=", v)
    end
    # self.send(:name=, hash[:name])
    # self.send(:url=, hash[:url])
    # @category = category
    # binding.pry

    @@all << self
  end

  def add_info(hash)
    hash.each do |k, v|
      self.send("#{k}=", v)
    end
    # self.send(:summary=, hash[:summary])
    # self.send(:release_date= , hash[:release_date])
    # self.send(:developer= , hash[:developer])
    # self.send(:category= , hash[:category])
    # self.send(:price= , hash[:price])
    # self.send(:sale= , hash[:sale])
  end

  def self.all
    @@all
  end

def self.find_by_game_type(category)
  # binding.pry
  all.select {|game| game.category == category}

end

  # def save
  #   @@all << self
  # end

  # def self.destroy
  #   @@all.clear
  # end

end
