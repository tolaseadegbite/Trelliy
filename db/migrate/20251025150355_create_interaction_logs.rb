class CreateInteractionLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :interaction_logs do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :follow_up_task, null: false, foreign_key: true
      t.text :note

      t.timestamps
    end
  end
end
