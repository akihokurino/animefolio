class Content < ActiveRecord::Base
	class << self
		def find_or_create(title, film_id)
			unless self.exists?(title: title)
				self.create!(film_id: film_id, title: title)
				content_id = self.last[:id]
			else
				content = self.find_by(title: title)
				content_id = content[:id]
			end
		end
	end
end
