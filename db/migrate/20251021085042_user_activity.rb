class CreateUserActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false
      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end
  end
end
