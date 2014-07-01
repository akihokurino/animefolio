json.film do |json|
  json.id @film[:id]
  json.title @film[:title]
  json.description @film[:description]
  json.thumbnail @film[:thumbnail]
end

json.content do |json|
  json.id @content[:id]
  json.title @content[:title]
  json.links do |json|
    json.array!(@content.links) do |link|
      json.id link[:id]
      json.title link[:title]
      json.url link[:url]
    end
  end
end