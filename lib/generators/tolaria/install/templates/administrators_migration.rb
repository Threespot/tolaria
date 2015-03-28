class CreateAdministrators < ActiveRecord::Migration
  def change

    create_table :administrators, force:true do |t|

      t.timestamps

      t.string :email, null:false, index:true
      t.string :name, null:false
      t.string :organization, null:false

      t.string :passcode, limit:60, null:false
      t.string :auth_token, limit:32, null:false, index:true

      t.datetime :account_unlocks_at, null:false
      t.datetime :passcode_expires_at, null:false

      t.integer :lockout_strikes, null:false, default:0

      t.integer :total_strikes, null:false, default:0
      t.integer :sessions_created, null:false, default:0

    end

  end
end
