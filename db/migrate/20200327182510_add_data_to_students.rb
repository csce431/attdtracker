class AddDataToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :google_token, :string
    add_column :students, :google_refresh_token, :string
  end
end
