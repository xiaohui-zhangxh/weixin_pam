require 'weixin_pam/api_error'
module WeixinPam
  class PublicAccount < ActiveRecord::Base
    include WeixinRailsMiddleware::AutoGenerateWeixinTokenSecretKey

    has_many :user_accounts, dependent: :destroy
    has_many :diymenus, dependent: :destroy
    has_many :parent_menus, -> { includes(:sub_menus).where(parent_id: nil, is_show: true).order("sort").limit(3) }, class_name: "WeixinPam::Diymenu", foreign_key: :public_account_id

    before_save :set_default_values

    def client
      @client ||= WeixinAuthorize::Client.new(app_id, app_secret)
    end

    def reply_weixin(message, keyword)
      klass = reply_class.present? ? reply_class.constantize : PublicAccountReply
      klass.new(self, message, keyword).reply
    end

    def build_menu
      Jbuilder.encode do |json|
        json.button(parent_menus) do |menu|
          json.name menu.name
          if menu.has_sub_menu?
            json.sub_button(menu.sub_menus) do |sub_menu|
              json.type sub_menu.button_type
              json.name sub_menu.name
              sub_menu.button_type_json(json)
            end
          else
            json.type menu.button_type
            menu.button_type_json(json)
          end
        end
      end
    end

    def upload_menu
      client.create_menu(build_menu)
    end

    def download_menu!
      ret = client.menu
      fail ApiError::FailedResult.new(ret, '下载公众号菜单失败') unless ret.ok?
      # Reset menu
      diymenus.where(parent: nil).update_all(is_show: false)
      data = ret.result
      return unless data.key?('menu') && data['menu'].key?('button')

      i = 0
      data['menu']['button'].each do |button|
        i += 1
        sub_buttons = button.delete('sub_button')
        button['button_type'] = Diymenu::button_types[button.delete('type')]
        parent_menu = diymenus.find_or_initialize_by(button)
        parent_menu.parent = nil
        parent_menu.is_show = true
        parent_menu.sort = i
        parent_menu.save! if parent_menu.changed?
        parent_menu.diymenus.update_all(parent_id: nil, is_show: false)

        j = 0
        sub_buttons.each do |sub_button|
          j += 1
          sub_button.delete('sub_button')
          sub_button['button_type'] = Diymenu::button_types[sub_button.delete('type')]
          sub_menu = diymenus.find_or_initialize_by(sub_button)
          sub_menu.parent = parent_menu
          sub_menu.is_show = true
          sub_menu.sort = j
          sub_menu.save! if sub_menu.changed?
        end
      end
    end

    def temp_qrcode
      client.qr_code_url(client.create_qr_scene(1).result['ticket'])
    end

    private

    def set_default_values
      self.reply_class = 'CommonWeixinReplyService' if reply_class.blank?
    end
  end
end
