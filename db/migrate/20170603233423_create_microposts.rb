class CreateMicroposts < ActiveRecord::Migration[5.1]

  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.timestamps
    end

    #
    # use case: fetch all microposts for given user,
    #           in reverse order of creation.
    #
    add_index :microposts, [:user_id, :created_at] # listing 13.3
  end

end
