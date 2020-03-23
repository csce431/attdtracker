class User < ApplicationRecord
    has_and_belongs_to_many :courses
    #validates :fname, presence: true
    #validates :lname, presence: true
    #validates :uin, length: {is: 9}
    #format: { with: /[\%](\d{16}[\?])[\;](\1)[\+](\1)/ }
    validates :email, presence: true, format: {with: /tamu.edu\z/}
    #validates_format_of :email, :with => /\wa/
    #validates :fname, presence: true
    #validates :fname, presence: true
    
    def self.create_from_omniauth(access_token)
        #data = access_token.info
        #user = User.where(email: data['email']).first

        # Creates a new user only if it doesn't exist
    	where(email: access_token.info.email).first_or_initialize do |user|
            user.uid = access_token.uid # unique id? might not need
            user.name = access_token.info.name
            user.email = access_token.info.email
            user.img_url = access_token.info.image
        end
    end
end
