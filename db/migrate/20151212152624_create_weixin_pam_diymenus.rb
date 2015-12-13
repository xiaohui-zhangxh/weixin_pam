class CreateWeixinPamDiymenus < ActiveRecord::Migration
  def change
    create_table :weixin_pam_diymenus do |t|
      t.references :public_account, index: true
      t.references :parent
      t.string :name
      t.string :key
      t.string :url
      t.boolean :is_show
      t.integer :sort

      t.timestamps null: false
    end
    add_index :weixin_pam_diymenus, [:public_account_id, :parent_id]
    add_index :weixin_pam_diymenus, [:public_account_id, :key]
  end
end
