class Problem < ApplicationRecord
    has_many :recent_problems, dependent: :delete_all
    belongs_to :contest
end
