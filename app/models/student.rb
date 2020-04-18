class Student < ApplicationRecord
    has_and_belongs_to_many :courses
    
    validates :fname, :presence => {message: "First Name cannot be blank."}
    validates :lname, :presence => {message: "Last Name cannot be blank."}
    
    # validates :card_num, presence: true
    # validates :card_num, format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/, message: "Card format is invalid." }
    validates :card_num, :uniqueness => {message: "A student with this card number already exists."}, allow_blank: true

    validates :email, :presence => {message: "Email cannot be blank."}
    validates :email, format: {with: /tamu.edu\z/, message: "Email is invalid. Please enter a valid TAMU Email."}
    validates :email, :uniqueness => {message: "A student with this email already exists."}
end
