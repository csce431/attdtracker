class Teacher < ApplicationRecord
    has_and_belongs_to_many :courses, dependent: :destroy
    validates :lname, presence: true
    validates :fname, presence: true
    validates :department, length: {is: 4}
end
