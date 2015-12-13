module WeixinPam
  class Diymenu < ActiveRecord::Base
    CLICK_TYPE = "click".freeze # key
    VIEW_TYPE  = "view".freeze  # url

    validates_uniqueness_of :name

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
      view_type? ? (jbuilder.url url) : (jbuilder.key key)
    end

    def view_type?
      type == VIEW_TYPE
    end
  end
end
