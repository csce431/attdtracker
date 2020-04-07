class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.belongs_to :course
      t.string :classday
      
      t.timestamps
    end
    
    create_table :cards_courses do |t|
      t.references :card, foreign_key: true
      t.references :course, foreign_key: true
      
      t.timestamps
    end
    
    create_table :cards_days do |t|
      t.references :card, foreign_key: true
      t.references :day, foreign_key: true
      
      t.timestamps
    end
  end
end
