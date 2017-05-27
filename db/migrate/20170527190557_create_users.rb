class CreateUsers < ActiveRecord::Migration[5.1]
  def change
  	# listing 6.2
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
