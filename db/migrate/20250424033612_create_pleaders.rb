class CreatePleaders < ActiveRecord::Migration[8.0]
  def change
    create_table :pleaders do |t|
      t.string :stat
      t.string :name1
      t.string :stat1
      t.string :name2
      t.string :stat2
      t.string :name3
      t.string :stat3
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
