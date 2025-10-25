class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :name, null: false
      t.datetime :starts_at, null: false
      t.integer :duration_in_minutes, null: false

      t.timestamps
    end
  end
end
