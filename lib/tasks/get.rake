namespace :get do
 	desc "scraping from animepost"
  task :animepost => :environment do
	   require 'open-uri'
		require 'nokogiri'
		require 'kconv'

		def ranking(url)
			ranking_list = []
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".rank ul li a").each do |node|
				ranking_list << node.children.text
			end

			ranking_list
		end

		def recent(url)
			recent_list = []
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".sidemenu_body > dt").each do |node|
				if node.children.text == "放送中のアニメ一覧"
					node.next.next.css(".L2 a").each do |node|
						recent_list << node.children.text
					end
				end
			end

			recent_list
		end

		def newer(url)
			new_list = []
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".sidemenu_body > dt").each do |node|
				if node.children.text == "放送中のアニメ一覧"
					node.next.next.css(".L2").each do |node|
						tmp = {}
						node.children.each do |node|
							if node.name == "a"
								tmp[:url] =  node.attributes["href"].value
								tmp[:title] = node.children.text
							end
							if node.name == "span"
								if node.attributes["class"].value == "Txt15"
									tmp[:flag] = node.children.text
								end
							end
						end

						if tmp[:flag] == "新"
							new_list << tmp
						end
					end
				end
			end

			new_list
		end

		def crawl_hiragana(url, ranking_list, recent_list, new_list)
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".aniTtl .Ttl_btnA a").each do |node|
				first_letter = node.text
				crawl_title(node.attributes["href"].value, first_letter, ranking_list, recent_list, new_list)
			end
		end

		def crawl_title(url, first_letter, ranking_list, recent_list, new_list)
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".entry_body .sl_l a").each do |node|
				title = node.text
				popular = ranking_list.include?(title) ? true : false
				recent = recent_list.include?(title) ? true : false
				is_new = false
				new_list.each do |obj|
					if obj[:title] == title
						is_new = true
					end
				end
				get_basic(node.attributes["href"].value, title, first_letter, popular, recent, is_new)
			end
		end

		def get_basic(url, title, first_letter, popular, recent, is_new)
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

			film_id = Film.find_or_create(title, description, thumbnail, first_letter, popular, recent, is_new)
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

		url = "http://animepost.blog.fc2.com"
		ranking_list = ranking(url)
		recent_list = recent(url)
		new_list = newer(url)

		p new_list

		crawl_hiragana(url, ranking_list, recent_list, new_list)

		new_list.each do |obj|
			if Film.exists?(title: obj[:title])
				film = Film.find_by(title: obj[:title])
				film.update(is_new: true)
			else
				get_basic(obj[:url], obj[:title], nil, false, true, true)
			end
		end
  end
end
