Rails.application.routes.draw do

  mount WeixinPam::Engine => "/weixin_pam"
end
