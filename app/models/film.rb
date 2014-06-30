class Film < ActiveRecord::Base
	has_many :contents

	scope :search_by_keyword, -> (keyword) {
		where(["title like ?", "%#{keyword}%"])
	}

	scope :pagenation, -> (offset_num, get_num) {
		order("created_at ASC").offset(offset_num).limit(get_num)
	}

	class << self
		def find_or_create(title, description, thumbnail, first_letter)
			unless self.exists?(title: title)
				self.create!(title: title, description: description, thumbnail: thumbnail, first_letter: first_letter)
				film_id = self.last[:id]
			else
				film = self.find_by(title: title)
				film_id = film[:id]
			end
		end

		def get_associated(offset_num, get_num, letter, keyword)
			if letter
				self.where(first_letter: letter).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
			elsif keyword
				self.search_by_keyword(self.escape_like(keyword)).select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
			else
				self.all.select(:id, :title, :thumbnail).pagenation(offset_num, get_num)
			end
		end

		def escape_like(string)
		  	string.gsub(/[\\%_]/){|m| "\\#{m}"} if string
		end
	end
end
