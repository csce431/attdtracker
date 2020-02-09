class CreateHomes < ActiveRecord::Migration[5.2]
  def change
    create_table :homes do |t|
      t.string :card
      t.string :name

      t.timestamps
    end
  end
end
