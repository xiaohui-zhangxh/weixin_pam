class CreateWeixinPamUserAccounts < ActiveRecord::Migration
  def change
    create_table :weixin_pam_user_accounts do |t|
      t.references :weixin_pam_public_account, index: true, foreign_key: true
      t.string :uid
      t.string :nickname
      t.string :headshot
      t.boolean :subscribed

      t.timestamps null: false
    end
  end
end
