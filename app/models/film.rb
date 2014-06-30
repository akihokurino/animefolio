class Film < ActiveRecord::Base
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

		def get_associated(offset_num, get_num)
			self.all.select(:id, :title, :thumbnail).order("created_at ASC").offset(offset_num).limit(get_num)
		end
	end
end
