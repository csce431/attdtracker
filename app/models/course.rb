class Course < ApplicationRecord
    before_create :upcase_fields
    before_update :upcase_fields

    has_and_belongs_to_many :students
    has_and_belongs_to_many :cards
    has_many :days, dependent: :destroy
    
    # validates :name, presence: true, length: {minimum: 4}
    validates :name, :presence => {message: "Department code cannot be blank."}
    validates :name, :length => {is: 4, message: "Department code must be 4 characters long."}
    validates :name, format: {with: /\A[a-zA-Z]+\z/, message: "Department code is invalid."}

    # validates :number, presence: true, length: {is: 3}
    validates :number, :presence => {message: "Course number cannot be blank."}
    validates :number, :length => {is: 3, message: "Course number must be three digits."}

    # validates :section, presence: true, length: {is: 3}
    validates :section, :presence => {message: "Section number cannot be blank."}
    validates :section, :length => {is: 3, message: "Section number must be three digits."}

    # validates :year, presence: true, length: {minimum: 4}

    def upcase_fields
        self.name.upcase!
    end
end
