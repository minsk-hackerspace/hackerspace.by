json.array!(@users) do |user|
  json.merge! user.attributes
  json.paid_until user.paid_until
  json.url user_url(user, format: :json)
end
