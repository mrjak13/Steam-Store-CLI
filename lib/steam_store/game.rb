class SteamStore::Game
  attr_accessor :name, :url, :summary, :release_date, :developer, :category, :price, :sale

  @@all = []

  def initialize(hash)
    self.send(:name=, hash[:name])
    self.send(:url=, hash[:url])
    save
  end

  def add_info(hash)
    self.send(:summary=, hash[:summary])
    self.send(:release_date= , hash[:release_date])
    self.send(:developer= , hash[:developer])
    self.send(:category= , hash[:category])
    self.send(:price= , hash[:price])
    self.send(:sale= , hash[:sale])
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def self.destroy
    @@all.clear
  end

end
