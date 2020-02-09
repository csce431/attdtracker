class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :preferredname
      t.string :class
      
      t.timestamps
    end
  end
end
