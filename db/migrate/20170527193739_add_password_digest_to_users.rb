class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]

  def change
    add_column :users, :password_digest, :string # listing 6.35
  end
  
end
