class CreateTables < ActiveRecord::Migration[5.0]
  def change
     create_table :users do |t|
     t.index :ID
	 t.integer :Phone
	 t.string :Name
	 t.integer :Points
	 t.string :Languages
     t.timestamps
	 end
	 
     create_table :translations do |t|
     t.index :ID
	 t.integer :User_ID
	 t.string :Languages	 
	 t.string :Phrase
	 t.string :Traslation
     t.timestamps
	 end
	 
     create_table :dailywords do |t|
     t.index :ID
	 t.integer :User_ID
	 t.string :Languages	 
	 t.string :Word
	 t.string :Traslation
     t.timestamps
	 end
	 
  end

end
