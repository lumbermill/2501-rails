class Event < ApplicationRecord
    has_many :votes, dependent: :destroy
    belongs_to :user, optional: true

    validates :title, presence: true
    validates :schedules, presence: true

    has_rich_text :description

    def schedules_array
        schedules.split(',').map(&:strip)
    end

    def count_votes
        l = schedules_array.length
        o = [0] * l
        x = [0] * l
        votes.each do |vote|
            vote.answers_array.each_with_index do |answer, index|
                if answer == 'o'
                    o[index] += 1
                elsif answer == 'x'
                    x[index] += 1
                end
            end
        end
        {o: o, x: x}
    end

    def indexes_of_top_schedules
        counts = count_votes
        o = counts[:o]
        max_count = o.max
        indexes = []
        return indexes if max_count == 0
        o.each_with_index do |count, index|
            indexes << index if count == max_count
        end
        if indexes.length > 1
            x = counts[:x]
            min_count = x.each_with_index.select { |v, i| indexes.include?(i) }.map { |count, index| count }.min
            indexes = []
            x.each_with_index do |count, index|
                indexes << index if count == min_count
            end
        end
        indexes
    end

    def token
        Digest::SHA1.hexdigest("#{id}-#{created_at}").slice(0, 8)
    end
end
