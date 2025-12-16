class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contents, %i[user_id title], unique: true
  end
end
