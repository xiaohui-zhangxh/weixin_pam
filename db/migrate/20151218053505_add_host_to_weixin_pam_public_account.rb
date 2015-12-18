class AddHostToWeixinPamPublicAccount < ActiveRecord::Migration
  def change
    add_column :weixin_pam_public_accounts, :host, :string
    add_index :weixin_pam_public_accounts, :host
  end
end
