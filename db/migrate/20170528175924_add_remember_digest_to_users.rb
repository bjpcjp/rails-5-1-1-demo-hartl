class AddRememberDigestToUsers < ActiveRecord::Migration[5.1]

  def change # listing 9.1
    add_column :users, :remember_digest, :string
  end
end
