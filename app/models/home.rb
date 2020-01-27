class Home < ApplicationRecord
    #validates :card, presence: true,
    #                length: { minimum: 54, maximum: 56}
    validates :card, presence: true,
                    length: { minimum: 1, maximum: 56}
    validates :name, presence: true
    validates :name, uniqueness: true
end

