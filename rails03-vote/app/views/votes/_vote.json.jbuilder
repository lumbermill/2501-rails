json.extract! vote, :id, :event_id, :name, :answers, :comment, :created_at, :updated_at
json.url vote_url(vote, format: :json)
