class AddCreatorToContacts < ActiveRecord::Migration[8.0]
  def change
    add_reference :contacts, :creator, null: false, foreign_key: { to_table: :users }
  end
end
