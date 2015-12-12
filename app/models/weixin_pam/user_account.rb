module WeixinPam
  class UserAccount < ActiveRecord::Base
    belongs_to :public_account
  end
end
