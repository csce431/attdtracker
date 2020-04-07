class Card < ApplicationRecord
    has_and_belongs_to_many :days
    has_and_belongs_to_many :courses
    
    ### card's code format is commented out for debugging purposes
    ### see the regex in action ---> https://regex101.com/r/nVsnUJ/2
    validates :code, presence: true#, format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/ }
    validates :code, uniqueness: true
    #validates :email, presence: true
    validates :email, uniqueness: true
end
