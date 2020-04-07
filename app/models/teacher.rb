class Teacher < ApplicationRecord
    has_many :courses, dependent: :destroy
    validates :lname, presence: true
    validates :fname, presence: true
    validates :email, presence: true, format: {with: /tamu.edu\z/}
    validates :department, length: {is: 4}
end
