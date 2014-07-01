class ContentsController < ApplicationController
	def show
		@film = Film.find(params[:film_id])
		@content = Content.find(params[:id])
	end
end
