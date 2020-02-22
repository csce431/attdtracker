class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.belongs_to :course
      t.string :classday
      
      t.timestamps
    end
    
    #create_table :courses_days, id: false do |t|
    #  t.belongs_to :course
    #  t.belongs_to :day
    #end
  end
end
