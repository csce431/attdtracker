class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :number
      t.integer :section
      t.integer :year
      t.string :season

      t.timestamps
    end
    
    create_table :students do |t| 
      t.string :fname
      t.string :mname
      t.string :lname
      t.string :prefname
      t.integer :uin
      t.string :email
      t.binary :picture
      t.string :card_num

      t.timestamps
    end
  end
end
