class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.string :classday
      
      t.timestamps
    end
    
    create_table :courses_days do |t|
      t.references :course, foreign_key: true
      t.references :day, foreign_key: true
      
      t.timestamps
    end
  end
end
