class Day < ApplicationRecord
    belongs_to :courses, optional: true
    has_and_belongs_to_many :card
end
