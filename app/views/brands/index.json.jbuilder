json.array!(@brands) do |brand|
  json.extract! brand, :id, :title, :header
  json.url brand_url(brand, format: :json)
end
