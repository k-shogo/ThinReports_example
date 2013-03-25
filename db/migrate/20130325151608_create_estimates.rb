class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.string :no
      t.string :customer
      t.integer :total_price
      t.string :place

      t.timestamps
    end
  end
end
