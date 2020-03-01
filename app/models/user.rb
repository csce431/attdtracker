class User < ApplicationRecord
    def self.create_from_omniauth(access_token)
        #data = access_token.info
        #user = User.where(email: data['email']).first

        # Creates a new user only if it doesn't exist
        where(email: auth.info.email).first_or_initialize do |user|
            user.uid = auth.uid # unique id? might not need
            user.name = auth.info.name
            user.email = auth.info.email
            user.img_url = auth.info.image
        end
    end
end