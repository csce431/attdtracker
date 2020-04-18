class Student < ApplicationRecord
    has_and_belongs_to_many :courses
    
    # validates :fname, presence: true
    # validates :lname, presence: true
    validates :fname, :presence => {:message => "First Name cannot be blank."}
    validates :lname, :presence => {:message => "Last Name cannot be blank."}
    
    # validates :card_num, presence: true, format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/ }
    validates :card_num, :uniqueness => {:message => "A student with this card number already exists."}, allow_blank: true
    # validates :card_num, uniqueness: true, allow_blank: true

    validates :email, presence: true, format: {with: /tamu.edu\z/}
    # validates :email, uniqueness: true
    validates :email, :uniqueness => {:message => "A student with this email already exists."}
end
