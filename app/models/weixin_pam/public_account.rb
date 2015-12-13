module WeixinPam
  class PublicAccount < ActiveRecord::Base
    has_many :user_accounts, dependent: :destroy
    has_many :diymenus, dependent: :destroy
    has_many :parent_menus, -> { includes(:sub_menus).where(parent_id: nil, is_show: true).order("sort").limit(3) }, class_name: "WeixinPam::Diymenu", foreign_key: :public_account_id
    # has_many :enabled_parent_menus, -> { includes(:sub_menus).where(parent_id: nil, is_show: true).order("sort") }, class_name: "WeixinPam::Diymenu", foreign_key: :public_account_id
    # has_many :disabled_parent_menus, -> { includes(:sub_menus).where(parent_id: nil, is_show: false).order("sort") }, class_name: "WeixinPam::Diymenu", foreign_key: :public_account_id

    def client
      @client ||= WeixinAuthorize::Client.new(app_id, app_secret)
    end

    def build_menu
      Jbuilder.encode do |json|
        json.button(parent_menus) do |menu|
          json.name menu.name
          if menu.has_sub_menu?
            json.sub_button(menu.sub_menus) do |sub_menu|
              json.type sub_menu.type
              json.name sub_menu.name
              sub_menu.button_type(json)
            end
          else
            json.type menu.type
            menu.button_type(json)
          end
        end
      end
    end

    def upload_menu
      client.create_menu(build_menu)
    end
  end
end
