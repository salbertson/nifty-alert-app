class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :description
      t.string :recipients, array: true, default: []
      t.integer :current_number
      t.integer :threshold
    end
  end
end
