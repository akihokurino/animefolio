namespace :get do
  desc "scraping from animemap"
  task :animemap => :environment do
    require 'open-uri'
    require 'nokogiri'
    require 'kconv'

    def crawl_area_map(url)
      html     = open(url){ |f| f.read }
      doc      = Nokogiri::HTML.parse(html.toutf8, nil, "UTF-8")

      map      = []
      pre_week = nil
      id       = 1

      doc.css(".time-table .onair").each do |node|
        anime = {
          id: id,
          week: nil,
          title: nil,
          now_episode: nil,
          time: nil
        }

        node.children.each do |node|
          if node.attributes["class"].value =~ /week/
            pre_week     = node.children.text
            anime[:week] = node.children.text
          else
            anime[:week] = pre_week
          end

          if node.attributes["class"].value =~ /title/
            node.children.each do |node|
              anime[:title] = node.attributes["title"].value
            end
          end

          if node.attributes["class"].value =~ /now_episode/
            anime[:now_episode] = node.children.text
          end

          if node.attributes["class"].value =~ /time/
            anime[:time] = node.children.text
          end
        end

        map << anime
        id += 1
      end

      AnimeMap.delete_all
      map.each do |anime|
        AnimeMap.create anime
      end
    end

    crawl_area_map("http://animemap.net/time/table/tokyo/")
  end
end
