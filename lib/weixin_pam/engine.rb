module WeixinPam
  class Engine < ::Rails::Engine
    isolate_namespace WeixinPam
    require 'bootstrap-sass'
    require 'sass-rails'
    require 'simple_form'
    require 'jquery-turbolinks'
    require 'weixin_authorize'
    require 'font-awesome-rails'
    require 'rails-i18n'
  end
end
