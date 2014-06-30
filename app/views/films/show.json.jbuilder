json.film do |json|
  json.id @film[:id]
  json.title @film[:title]
  json.description @film[:description]
  json.thumbnail @film[:thumbnail]
  json.contents do |json|
    json.array!(@film.contents) do |content|
      json.id content[:id]
      json.title content[:title]
    end
  end
end