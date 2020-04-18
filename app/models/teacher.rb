class Teacher < ApplicationRecord
    before_create :upcase_fields
    before_update :upcase_fields
    has_many :courses, dependent: :destroy

    validates :fname, :presence => {message: "First Name cannot be blank."}
    validates :lname, :presence => {message: "Last Name cannot be blank."}

    validates :email, :presence => {message: "Email cannot be blank."}
    validates :email, format: {with: /tamu.edu\z/, message: "Email is invalid. Please enter a valid TAMU Email."}
    validates :email, :uniqueness => {message: "An instructor with this email already exists."}
    
    validates :department, length: {is: 4, message: "Department code must be 4 characters long."}
    validates :department, format: {with: /\A[a-zA-Z]+\z/, message: "Department code is invalid."}

    def upcase_fields
        self.department.upcase!
    end
end
