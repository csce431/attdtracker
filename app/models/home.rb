class Home < ApplicationRecord
    validates :card, presence: true,
                    length: { minimum: 0, maximum: 56}
    validates :card, uniqueness: true
    validates :name, presence: true
    validates :name, uniqueness: true
end