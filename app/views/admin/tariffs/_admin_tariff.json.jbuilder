json.extract! admin_tariff, :id, :ref_name, :name, :description, :access_allowed, :monthly_price, :created_at, :updated_at
json.url admin_tariff_url(admin_tariff, format: :json)
