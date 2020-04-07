class Admin < ApplicationRecord
    validates :email, presence: true, format: {with: /tamu.edu\z/}
end
