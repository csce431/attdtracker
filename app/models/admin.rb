class Admin < ApplicationRecord
    validates :fname, :presence => {message: "First Name cannot be blank."}
    validates :lname, :presence => {message: "Last Name cannot be blank."}

    validates :email, :presence => {message: "Email cannot be blank."}
    validates :email, format: {with: /tamu.edu\z/, message: "Email is invalid. Please enter a valid TAMU Email."}
    validates :email, :uniqueness => {message: "An admin with this email already exists."}
end
