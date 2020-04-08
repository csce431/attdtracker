class Admin < ApplicationRecord
    validates :lname, presence: true
    validates :email, presence: true, format: {with: /tamu.edu\z/}
end
