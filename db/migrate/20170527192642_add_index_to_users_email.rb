class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]

  def change
  	add_index :users, :email, unique: true # listing 6.29
  end

end
