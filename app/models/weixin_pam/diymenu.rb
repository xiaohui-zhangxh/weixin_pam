module WeixinPam
  class Diymenu < ActiveRecord::Base
    CLICK_TYPE = "click".freeze # key
    VIEW_TYPE  = "view".freeze  # url

    validates_presence_of :name
    validates_presence_of :key, if: -> { url.blank? }
    validates_presence_of :url, if: -> { key.blank? }
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

    def type
      key.present? ? CLICK_TYPE : VIEW_TYPE
    end

    def button_type(jbuilder)
      view? ? (jbuilder.url url) : (jbuilder.key key)
    end

    def view?
      type == VIEW_TYPE
    end

    def click?
      type == CLICK_TYPE
    end

    def displayable_name
      str = case type
            when CLICK_TYPE
              key
            when VIEW_TYPE
              url
            end
      "#{name} (#{type} - #{str}) "
    end

    private

    def set_default_values
      self.is_show = false if is_show.blank?
      self.sort = (public_account.diymenus.order('sort desc').first.try(:sort) || 0) + 1 if self.sort.blank?
    end
  end
end
