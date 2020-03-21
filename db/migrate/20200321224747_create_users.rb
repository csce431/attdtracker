class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :fname
      t.string :lname
      t.string :email
      t.string :picture

      t.timestamps
    end
  end
end
