class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :fname
      t.string :mname
      t.string :lname
      t.string :prefname
      t.integer :uin
      t.string :email
      t.binary :picture
      t.string :card
      t.string :role
      
      t.timestamps
    end
    
    create_table :courses_users do |t|
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true
      
      t.timestamps
    end
  end
end
