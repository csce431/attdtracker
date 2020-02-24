class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.belongs_to :courses, index: true
      t.string :code
      t.string :email
      t.string :firstname
      t.string :lastname
      
      t.timestamps
    end
  end
end
