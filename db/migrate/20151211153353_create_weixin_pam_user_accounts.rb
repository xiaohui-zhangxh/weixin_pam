class CreateWeixinPamUserAccounts < ActiveRecord::Migration
  def change
    create_table :weixin_pam_user_accounts do |t|
      t.references :public_account, index: true
      t.string :uid
      t.string :nickname
      t.string :headshot
      t.boolean :subscribed

      t.timestamps null: false
    end
    add_index :weixin_pam_user_accounts, [:public_account_id, :uid], unique: true
  end
end
