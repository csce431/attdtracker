class CreateTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers do |t|
      t.string :fname
      t.string :mname
      t.string :lname
      t.string :email
      
      t.timestamps
    end
    
    create_table :courses_teachers do |t|
      t.references :teacher, foreign_key: true
      t.references :course, foreign_key: true
      
      t.timestamps
    end
  end
end
