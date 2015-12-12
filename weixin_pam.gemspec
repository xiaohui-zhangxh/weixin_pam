$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "weixin_pam/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "weixin_pam"
  s.version     = WeixinPam::VERSION
  s.authors     = ["xiaohui"]
  s.email       = ["xiaohui@zhangxh.net"]
  s.homepage    = "https://github.com/xiaohui-zhangxh/weixin_pam"
  s.summary     = "A Rails engine to manage Weixin Public Accounts"
  s.description = "With this engine, you can manage multiple Weixin Public Accounts"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "bootstrap-sass", '~> 3.3.6'
  s.add_dependency "sass-rails", '>= 3.2'
  s.add_dependency "simple_form", "~> 3.2.0"
  s.add_dependency "sprockets-rails", "> 2.1.4"
  s.add_dependency 'jquery-turbolinks'
  s.add_dependency 'weixin_authorize'
  s.add_dependency "redis-namespace"

  s.add_development_dependency "sqlite3"
end
