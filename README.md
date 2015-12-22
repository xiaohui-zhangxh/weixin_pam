# 微信公众号管理工具
## WeixinPam(Weixin Public Account Management)

本Rails Engine是为了方便公众号运维人员统一管理公众号的开发接口，不同公众号由同一个Rails管理和驱动，对不同的公众号，可实现如下功能：

1. 修改自定义菜单
2. 实现网页授权登录，获取用户信息并保存在数据库
3. 接收微信服务器推送信息，实现自动回复和其他高级功能

## 如何使用


Gemfile:

```
gem 'weixin_pem'
```

config/routes:

```
mount WeixinPam::Engine => '/'
```

启动Rails server

```
bundle exec rails s
```

访问：http://localhost:3000/public_accounts 即可添加／删除公众号配置


## 修改自定义菜单

点击已添加的公众号名字，点击“微信菜单”按钮，该页面可实现如下功能

1. 下载公众号菜单
2. 上传公众号菜单
3. 添加菜单到数据库
4. 移动菜单到“未启用的列表”
5. 对菜单排序

## 如何使用多公众号网页授权

本例子使用Devise作为用户登录模块，用到gem omniauth-wechat-oauth2

Gemfile中：

```
gem 'devise'
gem "omniauth-wechat-oauth2"
```
config/initializers/devise.rb

```
require 'omniauth_setup'
# 此处 setup: OmniauthSetup是关键，他实现不同公众号的api身份切换
config.omniauth :wechat, nil, nil, setup: OmniauthSetup
```

lib/omniauth_setup.rb

```
class OmniauthSetup
  # OmniAuth expects the class passed to setup to respond to the #call method.
  # env - Rack environment
  def self.call(env)
    new(env).setup
  end

  # Assign variables and create a request object for use later.
  # env - Rack environment
  def initialize(env)
    @env = env
    @request = ActionDispatch::Request.new(env)
  end

  # The main purpose of this method is to set the consumer key and secret.
  def setup
    @env['omniauth.strategy'].options.merge!(custom_credentials)
    puts
    puts @env['omniauth.strategy'].options.inspect
    puts
  end

  private

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    h = {}
    scope = @request.params.delete(:scope).presence
    h[:scope] = scope if scope
    if account = WeixinPam::PublicAccount.find_by(host: @request.host)
      h.update client_id: account.app_id, client_secret: account.app_secret
    end
    h
  end

end
```

config/routes.rb

```
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
```

app/controllers/users/omniauth_callbacks_controller.rb

```
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def wechat
    public_account = WeixinPam::PublicAccount.find_by!(host: request.host)
    ua = WeixinPam::UserAccount.from_omniauth(public_account, request.env["omniauth.auth"])
    if ua.user.persisted?
      update_stored_location_url ua.user
      sign_in_and_redirect ua.user, :event => :authentication
      set_flash_message(:notice, :success, :kind => '微信') if is_navigational_format?
    else
      session["devise.wechat_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  private

  def update_stored_location_url(user)
    if url = request.env['omniauth.params']['redirect'] || request.env['omniauth.origin']
      store_location_for user, url
    end
  end
end

```
## 如何多公众号响应微信服务器事件推送

创建的公众号如果不填写"微信服务器事件推送的响应Class",WeixinPam会使用开发模式下的默认值PublicAccountReply（lib/public_account_reply.rb）

针对不同公众号，我们可以编写不同的Reply Class去继承PublicAccountReply,实现不同公众号有不同的回复内容。

## 用Devise保护资源

添加config/initializers/weixin_pam.rb,加入如下代码
```

WeixinPam::ApplicationController.class_eval do
  before_action :authenticate_user!
  before_action :ensure_admin_user

  private

  def ensure_admin_user
    fail "没有访问权限" unless current_user.admin?
  end
end
