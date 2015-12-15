class AddWeixinSecretKeyAndWeixinTokenToPublicAccounts < ActiveRecord::Migration
  def up
    add_column :weixin_pam_public_accounts, :weixin_secret_key, :string
    add_column :weixin_pam_public_accounts, :weixin_token, :string
    add_column :weixin_pam_public_accounts, :reply_class, :string
    add_index :weixin_pam_public_accounts, :weixin_secret_key
    add_index :weixin_pam_public_accounts, :weixin_token
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
