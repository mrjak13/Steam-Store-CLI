class SteamStore::Game
  attr_accessor :name, :url

  @@all = []

  def initialize(hash)
    self.send(:name=, hash[:name])
    self.send(:url=, hash[:url])
    save
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

end
