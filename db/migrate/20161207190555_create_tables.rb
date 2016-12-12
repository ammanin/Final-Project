class CreateTables < ActiveRecord::Migration[5.0]
  def change
     create_table :users do |t|
	 t.integer :phone
	 t.string :name
	 t.integer :points
	 t.string :languages
     t.timestamps
	 end
	 
     create_table :translations do |t|
	 t.integer :user_ID
	 t.string :languages	 
	 t.string :phrase
	 t.string :traslation
     t.timestamps
	 end
	 
     create_table :dailywords do |t|
	 t.integer :user_ID
	 t.string :languages	 
	 t.string :word
	 t.string :traslation
     t.timestamps
	 end
	 create_table :languages do |t|
	 t.string :language	 
	 t.string :language_code
	 end
  end

end
