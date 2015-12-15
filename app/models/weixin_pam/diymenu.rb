module WeixinPam
  class Diymenu < ActiveRecord::Base

    BUTTON_TYPES = {
      click: '点击推事件',
      view: '跳转URL',
      scancode_push: '扫码推事件',
      scancode_waitmsg: '扫码推事件且弹出“消息接收中”提示框',
      pic_sysphoto: '弹出系统拍照发图',
      pic_photo_or_album: '弹出拍照或者相册发图',
      pic_weixin: '弹出微信相册发图器',
      location_select: '弹出地理位置选择器',
      media_id: '下发消息（除文本消息）',
      view_limited: '跳转图文消息URL'
    }.freeze

    enum button_type: BUTTON_TYPES.keys.freeze

    validates_presence_of :name
    validates_presence_of :button_type, if: -> { parent.present? }
    validates_presence_of :key, if: -> { button_type.present? && !url_required? }
    validates_presence_of :url, if: :url_required?
    before_validation :set_default_values

    has_many :diymenus, foreign_key: :parent_id, dependent: :destroy
    has_many :sub_menus,
             -> { where(is_show: true).order('sort').limit(5) },
             class_name: 'Diymenu', foreign_key: :parent_id

    belongs_to :parent, foreign_key: :parent_id, class_name: "Diymenu"
    belongs_to :public_account

    def has_sub_menu?
      sub_menus.present?
    end

    def button_type_json(jbuilder)
      view? ? (jbuilder.url url) : (jbuilder.key key)
    end

    def displayable_name
      str = name
      str += " (#{button_type} - #{url_required? ? url : key}) " if button_type.present?
      str
    end

    private

    def set_default_values
      self.is_show = false if is_show.blank?
      self.sort = (public_account.diymenus.order('sort desc').first.try(:sort) || 0) + 1 if self.sort.blank?
    end

    def url_required?
      button_type.present? && (view? || view_limited?)
    end
  end
end
