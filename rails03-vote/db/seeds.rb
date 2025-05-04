# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create(email_address: "test@lmlab.net", password: "secret")

if Rails.env.development?
  # Create dummy events
  e1 = Event.create(title: "ダミーイベント1", description: "ダミーイベントの説明1", schedules: "4/25 17:00, 4/26 18:00, 4/27 19:00", user_id: 1)
  Vote.create(event: e1, name: "伊藤", answers: "o,x,?", comment: "ダミーコメント1")
  Vote.create(event: e1, name: "田中", answers: "o,o,o", comment: "ダミーコメント2")
end 