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
    # binding.pry
    all.find {|category| category.name == name}
  end

  def self.all
    @@all
  end

end
