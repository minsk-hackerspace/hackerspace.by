json.array!(@projects) do |project|
  json.extract! project, :id, :name, :short_desc, :full_desc, :image
  json.url project_url(project, format: :json)
end
