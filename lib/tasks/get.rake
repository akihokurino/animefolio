namespace :get do
 	desc "scraping from animepost"

  	task :animepost => :environment do
    	require 'open-uri'
		require 'nokogiri'
		require 'kconv'

		def crawl_hiragana(url)
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".aniTtl .Ttl_btnA a").each do |node|
				first_letter = node.text
				crawl_title(node.attributes["href"].value, first_letter)
			end
		end

		def crawl_title(url, first_letter)
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".entry_body .sl_l a").each do |node|
				title = node.text
				get_basic(node.attributes["href"].value, title, first_letter)
			end
		end

		def get_basic(url, title, first_letter)
			begin
				html = open(url){ |f| f.read }
			rescue Exception
				return
			end

			description = nil
			thumbnail = nil

			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".aniSto p.Txt2").each do |node|
				description = node.children.text if node.name == "p"
			end
			doc.css(".aniSto img").each do |node|
				thumbnail = node.attributes["src"].value if node.name == "img"
			end

			p "#{title} 開始"

			if description.nil? || thumbnail.nil?
				doc.css(".story p.t2").each do |node|
					description = node.children.text
				end
				doc.css(".story img").each do |node|
					thumbnail = thumbnail = node.attributes["src"].value if node.name == "img"
				end

			end

			film_id = Film.find_or_create(title, description, thumbnail, first_letter)
			crawl_list(doc, film_id)
		end

		def crawl_list(doc, film_id)
			exists_list = false
			catch :double_loop do
				doc.css("#more > div").each do |node|
					if node.attributes["class"] && node.attributes["class"].value == "aniMov"
						node.css("p.Txt4").each do |node|
							throw :double_loop if node.children.text == "関連アニメ動画"
						end

						exists_list = true
						node.css(".Mov_cnt .Mov_lst .Mov_ttl a").each do |node|
							url = node.attributes["href"].value
							html = open(url){ |f| f.read }
							doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
							crawl_list(doc, film_id)
						end

						break
					end
				end
			end

			unless exists_list
				get_details(doc, film_id)
			end
		end

		def get_details(doc, film_id)
			doc.css("#more > div").each do |node|
				title = nil
				content_id = nil

				if node.attributes["class"] && node.attributes["class"].value == "aniTabA"
					node.css(".Txt4").each do |node|
						title = node.children.text
						content_id = Content.find_or_create(title, film_id)
					end
					node.css("ul#tab1 li a").each do |node|
						get_links(node, content_id)
					end
				end
				if node.attributes["class"] && node.attributes["class"].value == "aniTabB"
					doc.css("#more > div.aniTabB > div").each_with_index do |node, index|
						if node.attributes["class"] && node.attributes["class"].value == "Tab_hed"
							title = node.children.children.text
							content_id = Content.find_or_create(title, film_id)
						end

						if node.attributes["class"] && node.attributes["class"].value =~ /Tab_cnt/
							node.css("ul li a").each do |node|
								get_links(node, content_id)
							end
						end
					end
				end
				if node.attributes["class"] && node.attributes["class"].value == "aniTabC"
					doc.css("#more > div.aniTabC > div").each_with_index do |node, index|
						if node.attributes["class"] && node.attributes["class"].value == "Tab_hed"
							title = node.children.children.text
							content_id = Content.find_or_create(title, film_id)
						end

						if node.attributes["class"] && node.attributes["class"].value =~ /Tab_cnt/
							node.css("ul li a").each do |node|
								get_links(node, content_id)
							end
						end
					end
				end
				if node.attributes["class"] && node.attributes["class"].value == "aniTabD"
					doc.css("#more > div.aniTabD").each_with_index do |node, index|
						node.css("#movie").each do |node|
							title = node.children.text
							content_id = Content.find_or_create(title, film_id)
						end
						node.css(".Tab_cnt ul li a").each do |node|
							get_links(node, content_id)
						end
					end
				end
			end

			p "正常に終了"
		end

		def get_links(node, content_id)
			case node.children.text
			when /AUE/
				title = node.children.text
				url = node.attributes["href"].value
			when "Trollvid"
				title = node.children.text
				url = node.attributes["href"].value
			when "VFun"
				title = node.children.text
				url = node.attributes["href"].value
			when "AniTube"
				title = node.children.text
				url = node.attributes["href"].value
			when "MP4up"
				title = node.children.text
				url = node.attributes["href"].value
			when "Hash"
				title = node.children.text
				url = node.attributes["href"].value
			when "Zunux"
				title = node.children.text
				url = node.attributes["href"].value
			end
			if !title.nil? && !url.nil?
				Link.create_or_update(content_id, title, url)
			end
		end

		crawl_hiragana("http://animepost.blog.fc2.com")
  	end
end
