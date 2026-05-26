class Blog < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  # content will be stored via Action Text (rich text)
  has_rich_text :content
  validates :content, presence: true
  validates :published, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
end
