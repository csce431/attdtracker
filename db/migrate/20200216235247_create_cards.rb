class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :code
      t.string :email
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :preferredname
      
      t.timestamps
    end
  end
end
