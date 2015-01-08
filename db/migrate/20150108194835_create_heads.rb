class CreateHeads < ActiveRecord::Migration
  def change
    create_table :heads do |t|
    	t.references :post, index: true

    	t.timestamps
    end
  end
end