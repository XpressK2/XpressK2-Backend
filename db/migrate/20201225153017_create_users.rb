class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :trade_role, null: false
      t.integer :status, default: 1
      t.string :country, null: false
      t.string :country_code, null: false
      t.string :telephone_no, null: false

      t.timestamps

      t.index %i[country_code telephone_no], unique: true
      t.index %i[email trade_role name status]
    end
  end
end
