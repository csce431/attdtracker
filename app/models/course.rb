class Course < ApplicationRecord
    has_and_belongs_to_many :students
    has_and_belongs_to_many :cards
    has_many :days, dependent: :destroy
    validates :name, presence: true, length: {minimum: 4}
    validates :number, presence: true, length: {is: 3}
    validates :section, presence: true, length: {is: 3}
    validates :year, presence: true, length: {minimum: 4}
end
