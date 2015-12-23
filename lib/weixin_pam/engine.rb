module WeixinPam
  class Engine < ::Rails::Engine
    isolate_namespace WeixinPam

    require_relative 'public_account_reply'
    require_relative 'api_error'

    require 'bootstrap-sass'
    require 'sass-rails'
    require 'simple_form'
    require 'jquery-turbolinks'
    require 'weixin_authorize'
    require 'font-awesome-rails'
    require 'rails-i18n'
    require 'weixin_rails_middleware'

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
  end
end
