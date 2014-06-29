class Film < ActiveRecord::Base
	class << self
		def find_or_create(title, description, thumbnail)
			unless self.exists?(title: title)
				self.create!(title: title, description: description, thumbnail: thumbnail)
				film_id = self.last[:id]
			else
				film = self.find_by(title: title)
				film_id = film[:id]
			end
		end
	end
end
