class Home < ApplicationRecord
    ### uncomment the following if you are lazy to swipe, or if you don't have your card and reader 
    # validates :card, presence: true, length: { minimum: 0, maximum: 56 }
    validates :card, uniqueness: true

    ### comment the following line if you don't have your card and reader)
    validates :card, format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/ }
    ### see the regex in action ---> https://regex101.com/r/nVsnUJ/2

    validates :name, presence: true
    validates :name, uniqueness: true
end