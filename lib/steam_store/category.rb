class SteamStore::Category
  extend SteamStore::Findable

  attr_accessor :name, :games

  @@all =[]

  def initialize(name)
    @name = name
    @games = []
    @@all << self
  end

  def self.all
    @@all
  end

end
