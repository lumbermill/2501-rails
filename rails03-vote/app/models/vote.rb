class Vote < ApplicationRecord
  belongs_to :event

  validates :name, presence: true
  validates :answers, presence: true

  def answers_array
    answers.split(",").map(&:strip)
  end

  def update_answers(params)
    raise "params can not be nil" unless params
    raise "can not find event for updating answers" unless event
    answers_array = [nil] * event.schedules_array.count
    answers_array.count.times do |i|
      answers_array[i] = params["answers_#{i}"]
    end
    self.answers = answers_array.join(",")
  end
end
