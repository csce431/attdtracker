class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.belongs_to :course
      t.string :code
      t.string :email
      
      t.timestamps
    end
  end
end
