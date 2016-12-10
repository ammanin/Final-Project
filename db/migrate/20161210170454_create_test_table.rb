class CreateTestTable < ActiveRecord::Migration[5.0]
  def change
	  create_table :status_updates do |t|

      t.string    :type_name
      t.text      :message
      t.integer   :duration
      t.timestamps

    end
  end
end
