class Home < ApplicationRecord
    validates :card, presence: true,
                    length: { minimum: 54, maximum: 56}
end

