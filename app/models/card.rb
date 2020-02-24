class Card < ApplicationRecord
    has_and_belongs_to_many :day #optional: true
    has_and_belongs_to_many :courses
    
    ### uncomment the following if you are lazy to swipe, or if you don't have your card and reader 
    ### see the regex in action ---> https://regex101.com/r/nVsnUJ/2
    validates :code, presence: true#, format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/ } 
end
