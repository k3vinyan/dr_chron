class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :doctor_id
      t.string :access_token
      t.string :refresh_token
      t.timestamps null: false
    end
  end
end
