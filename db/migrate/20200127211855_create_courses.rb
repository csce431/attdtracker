class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :section

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

      t.timestamps
    end
  end
end
