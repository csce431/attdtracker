class Student < ApplicationRecord
    has_and_belongs_to_many :courses
    
    validates :fname, :presence => {:message => "First Name cannot be blank"}
    validates :lname, :presence => {:message => "Last Name cannot be blank"}
    #validates_presence_of :lname, :message => "Last Name cannot be blank"
    
    #validates :uin, length: {is: 9}
    #format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/ }
    validates :email, presence: true, format: {with: /tamu.edu\z/}
    #validates_format_of :email, :with => /\wa/
    #validates :fname, presence: true
    #validates :fname, presence: true
end
