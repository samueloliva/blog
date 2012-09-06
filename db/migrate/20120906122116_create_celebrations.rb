class CreateCelebrations < ActiveRecord::Migration
  def change
    create_table :celebrations do |t|
      t.string :name
      t.date :celebrated_on
      t.text :message
      t.string :country

      t.timestamps
    end
  end
end
