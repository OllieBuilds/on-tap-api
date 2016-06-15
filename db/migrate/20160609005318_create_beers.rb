class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.boolean :favorite
      t.string :name
      t.string :abv
      t.string :image
      t.string :bdb_id
      t.timestamps null: false
    end
  end
end
