json.array!(@store_branches) do |store_branch|
  json.extract! store_branch, :id
  json.url store_branch_url(store_branch, format: :json)
end
