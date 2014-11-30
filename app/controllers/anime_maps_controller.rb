class AnimeMapsController < ApplicationController
  def index
    @result = AnimeMap.all
  end
end
