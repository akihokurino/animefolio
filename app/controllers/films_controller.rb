class FilmsController < ApplicationController
	before_action :pagenation, only: [:index]

	def index
		@films = Film.get_associated(@offset_num, @get_num, params[:letter], params[:keyword])
	end

	def show
		@film = Film.find(params[:id])
	end

	private
	def pagenation
		page_num = params[:page_num].to_i
		return if page_num < 0
		@get_num = 20
		@offset_num = (page_num - 1) * @get_num
	end
end
