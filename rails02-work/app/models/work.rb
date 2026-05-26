class Work < ApplicationRecord
  belongs_to :user
  has_paper_trail
end

# TODO 編集者を保存するには？ whodunnitを使う。ただし、paper_trail自体が動かない
