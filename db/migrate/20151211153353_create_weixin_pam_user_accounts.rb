class CreateWeixinPamUserAccounts < ActiveRecord::Migration
  def change
    create_table :weixin_pam_user_accounts do |t|
      t.references :public_account, index: true
      t.string :uid
      t.string :nickname
      t.string :sex
      t.string :province
      t.string :city
      t.string :country
      t.string :headimgurl
      t.boolean :subscribed, default: false, null: false
      t.string :headimg_fingerprint, limit: 32

      t.timestamps null: false
    end
    add_index :weixin_pam_user_accounts, [:public_account_id, :uid], unique: true
  end
end
