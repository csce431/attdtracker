class Course < ApplicationRecord
    has_and_belongs_to_many :students
    validates :name, presence: true, length: {minimum: 4}
    validates :section, presence: true, length: {is: 3}
end
