class RenameEventsToUserActivities < ActiveRecord::Migration[8.0]
  def change
    rename_table :events, :user_activities
  end
end
