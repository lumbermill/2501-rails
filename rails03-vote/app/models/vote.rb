class Vote < ApplicationRecord
    belongs_to :event

    validates :answers, presence: true

    def answers_array
        answers.split(",").map(&:strip)
    end
end
