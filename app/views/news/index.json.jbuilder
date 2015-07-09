json.array!(@news) do |news|
  json.extract! news, :id, :title, :short_desc, :description, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :user_id, :public
  json.url news_url(news, format: :json)
end
