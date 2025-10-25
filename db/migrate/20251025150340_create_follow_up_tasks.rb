class CreateFollowUpTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :follow_up_tasks do |t|
      t.references :invitation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :due_at, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
