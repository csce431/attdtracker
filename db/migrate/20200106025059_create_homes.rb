class CreateHomes < ActiveRecord::Migration[5.2]
  def change
    create_table :homes do |t|
      t.belongs_to :course
      t.string :card
      t.string :email

      t.timestamps
    end
  end
end
