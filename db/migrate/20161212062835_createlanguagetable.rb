class Createlanguagetable < ActiveRecord::Migration[5.0]
  def change
  create_table :languages do |t|
		t.string :lang	
		t.string :lang_code
		t.timestamps
  end
  end
end
