module WeixinPam
  class UserAccount < ActiveRecord::Base
    belongs_to :public_account
    before_save :set_headimg_fingerprint

    def self.from_omniauth(public_account, auth, auto_create = true)
      public_account.user_accounts.where(uid: auth.uid).send(auto_create ? "first_or_create" : "first_or_initialize") do |u|
        u.nickname = auth.info.nickname
        u.sex = auth.info.sex
        u.province = auth.info.province
        u.city = auth.info.city
        u.country = auth.info.country
        u.headimgurl = auth.info.headimgurl
      end
    end

    def self.sync_from_server(public_account)
      transaction do
        update_all subscribed: false
        public_account.client.followers.result['data']['openid'].each do |openid|
          u = find_or_initialize_by uid: openid
          u.public_account_id = public_account.id
          u.populate_with_api_info
          yield u if block_given?
          u.save if u.changed?
        end
      end
    end

    def api_info
      public_account.client.user(uid)
    end

    def same_with_headimg
      set_headimg_fingerprint
      return [] if headimg_fingerprint.blank?
      records = UserAccount.where(headimg_fingerprint: headimg_fingerprint).all.to_a
      records.delete_if { |r| r.id == id } if id
      records
    end

    def populate_with_api_info
      weixin_api_info = api_info
      if weixin_api_info.result['subscribe'] != 1
        self.subscribed = false
        return
      end
      self.subscribed = true
      [:nickname, :sex, :city, :province, :country, :headimgurl].each do |attr|
        send("#{attr}=", weixin_api_info.result[attr])
      end
    end

    private

    def set_headimg_fingerprint
      if headimgurl.present? && headimgurl_changed?
        Rails.logger.debug "Fetching headimg for weixin user #{public_account.id}-#{uid}..."
        self.headimg_fingerprint = Digest::MD5.hexdigest(open(headimgurl).read) rescue nil
        Rails.logger.debug "  Headimg fingerprint is #{headimg_fingerprint}"
      end
    end
  end
end
