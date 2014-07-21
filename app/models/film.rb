class Film < ActiveRecord::Base
	has_many :contents

	scope :search_by_keyword, -> (keyword) {
		where(["title like ?", "%#{keyword}%"])
	}

	scope :pagenation, -> (offset_num, get_num) {
		order("created_at ASC").offset(offset_num).limit(get_num)
	}

	class << self
		def find_or_create(title, description, thumbnail, first_letter, popular, recent, is_new)
			unless self.exists?(title: title)
				self.create!(title: title, description: description, thumbnail: thumbnail, first_letter: first_letter, popular: popular, recent: recent, is_new: is_new)
				film_id = self.last[:id]
			else
				film = self.find_by(title: title)
				film.update(thumbnail: thumbnail, popular: popular, recent: recent, is_new: is_new)
				film_id = film[:id]
			end
		end

		def get_associated(offset_num, get_num, letter, keyword, type)
			if letter
				self.where(first_letter: letter).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
			elsif keyword
				self.search_by_keyword(self.escape_like(keyword)).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
			elsif type
				case type
				when "popular"
					self.where(popular: true).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
				when "recent"
					self.where(recent: true).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
				when "new"
					self.where(is_new: true).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
				end
			else
				self.all.select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
			end
		end

		def escape_like(string)
		  	string.gsub(/[\\%_]/){|m| "\\#{m}"} if string
		end
	end
end
