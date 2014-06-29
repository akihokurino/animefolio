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
				crawl_title(node.attributes["href"].value)
			end
		end

		def crawl_title(url)
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".entry_body .sl_l a").each do |node|
				get_basic(node.attributes["href"].value)
			end
		end

		def get_basic(url)
			html = open(url){ |f| f.read }
			doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
			doc.css(".aniSto img").each do |node|
				p node.attributes["src"].value if node.name == "img"
			end
			doc.css(".aniSto h3").each do |node|
				p node.children.text if node.name == "h3"
			end
			doc.css(".aniSto p.Txt2").each do |node|
				p node.children.text if node.name == "p"
			end

			crawl_list(doc)
		end

		def crawl_list(doc)
			exists_list = false
			catch :double_loop do
				doc.css("#more > div").each do |node|
					if node.attributes["class"] && node.attributes["class"].value == "aniMov"
						node.css("p.Txt4").each do |node|
							throw :double_loop if node.children.text == "関連アニメ動画"
						end

						exists_list = true
						node.css(".Mov_cnt .Mov_lst .Mov_ttl a").each do |node|
							#p node.attributes["href"].value
							#p node.children.text
							html = open(node.attributes["href"].value){ |f| f.read }
							doc = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")
							crawl_list(doc)
						end

						break
					end
				end
			end

			unless exists_list
				get_details(doc)
			end
		end

		def get_details(doc)
			doc.css("#more > div").each do |node|
				if node.attributes["class"] && node.attributes["class"].value == "aniTabA"
					node.css(".Txt4").each do |node|
						p node.children.text
					end
					node.css("ul#tab1 li a").each do |node|
						get_links(node)
					end
				end
				if node.attributes["class"] && node.attributes["class"].value == "aniTabB"
					doc.css("#more > div.aniTabB > div").each_with_index do |node, index|
						if node.attributes["class"] && node.attributes["class"].value == "Tab_hed"
							p node.children.children.text
						end

						if node.attributes["class"] && node.attributes["class"].value =~ /Tab_cnt/
							node.css("ul li a").each do |node|
								get_links(node)
							end
						end
					end
				end
				if node.attributes["class"] && node.attributes["class"].value == "aniTabC"
					doc.css("#more > div.aniTabC > div").each_with_index do |node, index|
						if node.attributes["class"] && node.attributes["class"].value == "Tab_hed"
							p node.children.children.text
						end

						if node.attributes["class"] && node.attributes["class"].value =~ /Tab_cnt/
							node.css("ul li a").each do |node|
								get_links(node)
							end
						end
					end
				end
			end
		end

		def get_links(node)
			case node.children.text
			when "AUE"
				p node.attributes["href"].value
			when "Trollvid"
				p node.attributes["href"].value
			when "VFun"
				p node.attributes["href"].value
			when "AniTube"
				p node.attributes["href"].value
			when "MP4up"
				p node.attributes["href"].value
			when "Hash"
				p node.attributes["href"].value
			when "Zunux"
				p node.attributes["href"].value
			end
		end

		crawl_hiragana("http://animepost.blog.fc2.com")
  	end
end
