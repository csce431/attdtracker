class Day < ApplicationRecord
    has_and_belongs_to_many :courses #optional: true
    has_and_belongs_to_many :card
end
