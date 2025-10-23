class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      # This is the key for easy future expansion to Teams.
      # In the MVP, owner_type will always be 'User'.
      t.references :owner, polymorphic: true, null: false
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.text :how_we_met

      t.timestamps
    end
  end
end
