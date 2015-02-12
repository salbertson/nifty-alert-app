class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.timestamps
      t.string :description
      t.string :recipient
      t.integer :current_number
      t.integer :threshold
    end
  end
end
