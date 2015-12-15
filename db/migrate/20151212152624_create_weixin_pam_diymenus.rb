class CreateWeixinPamDiymenus < ActiveRecord::Migration
  def change
    create_table :weixin_pam_diymenus do |t|
      t.references :public_account, index: true
      t.references :parent
      t.integer :button_type
      t.string :name, null: false
      t.string :key
      t.string :url, limit: 128
      t.boolean :is_show, default: false, null: false
      t.integer :sort, default: 1, null: false

      t.timestamps null: false
    end
    add_index :weixin_pam_diymenus, [:public_account_id, :parent_id]
    add_index :weixin_pam_diymenus, [:public_account_id, :key]
  end
end
