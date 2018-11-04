# require "steam_store/version"

module SteamStore
  module Findable
    def find_by_name(name)
      all.find {|game| game.name == name}
    end
  end
end

require_relative '../config/environment'
