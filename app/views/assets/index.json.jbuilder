json.array!(@assets) do |asset|
  json.extract! asset, :id, :user_id
  json.url asset_url(asset, format: :json)
end
