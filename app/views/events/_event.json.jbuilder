json.extract! event, :id, :owner_id, :owner_type, :name, :starts_at, :duration_in_minutes, :created_at, :updated_at
json.url event_url(event, format: :json)
