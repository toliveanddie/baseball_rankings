class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
