class AddRoleToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :role, :integer
  end
end
