class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest, null: false
      t.integer :trade_role, default: 1
      t.integer :status, default: 1
      t.string :country
      t.string :country_code
      t.string :telephone_no
      t.boolean :third_party, default: false
      t.string :local_id

      t.timestamps

      t.index %i[country_code telephone_no], unique: true
      t.index %i[email trade_role name status]
    end
  end
end
