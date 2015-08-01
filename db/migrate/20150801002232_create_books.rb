class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string  :name,  null: false, default: ''
      t.integer :isbn,  null: false, default: 0
      t.integer :price, null: false, default: 0

      t.timestamps null: false
    end
  end
end
