class CreateWeixinPamPublicAccounts < ActiveRecord::Migration
  def change
    create_table :weixin_pam_public_accounts do |t|
      t.string :name
      t.string :app_id
      t.string :app_secret
      t.string :api_url
      t.string :api_token
      t.boolean :enabled

      t.timestamps null: false
    end
  end
end
