class Link < ActiveRecord::Base
	class << self
		def create_or_update(content_id, title, url)
			unless self.exists?(title: title, url: url)
				self.create!(content_id: content_id, title: title, url: url)
			else
				link = self.find_by(title: title)
				link.update(content_id: content_id, title: title, url: url)
			end
		end
	end
end
