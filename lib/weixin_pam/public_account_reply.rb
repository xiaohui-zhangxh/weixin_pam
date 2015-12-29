require 'weixin_rails_middleware/helpers/reply_weixin_message_helper'
module WeixinPam
  class PublicAccountReply

    class KeyEventCallback
      attr_accessor :key, :callback, :description
      def execute(service)
        callback.call(service)
      end
    end

    module KeyEventMethods
      extend ActiveSupport::Concern

      def find_key_event(key)
        key = key.to_s.intern
        self.class.key_event_callbacks.find { |ke| ke.key == key }
      end

      class_methods do
        def key_event_callbacks
          @key_event_callbacks ||= []
        end

        def key_event_desc(desc)
          @current_key_event = KeyEventCallback.new
          @current_key_event.description = desc
        end

        def define_key_event(key, &block)
          @current_key_event ||= KeyEventCallback.new
          @current_key_event.key = key.intern
          @current_key_event.callback = block
          key_event_callbacks.push(@current_key_event)
          @current_key_event = nil
        end
      end
    end

    include KeyEventMethods

    include WeixinRailsMiddleware::ReplyWeixinMessageHelper
    attr_reader :weixin_public_account, :weixin_message, :keyword, :weixin_user_account

    NO_CONTENT = :no_content

    def initialize(public_account, message, keyword)
      @weixin_public_account = public_account
      @weixin_user_account = public_account.user_accounts.find_or_create_by!(uid: message.FromUserName)
      @weixin_message = message
      @keyword = keyword
    end

    def reply
      send("response_#{@weixin_message.MsgType}_message")
    end

    def response_text_message
      reply_with_dev_message(reply_text_message("Your Message: #{@keyword}"))
    end

    # <Location_X>23.134521</Location_X>
    # <Location_Y>113.358803</Location_Y>
    # <Scale>20</Scale>
    # <Label><![CDATA[位置信息]]></Label>
    def response_location_message
      @lx    = @weixin_message.Location_X
      @ly    = @weixin_message.Location_Y
      @scale = @weixin_message.Scale
      @label = @weixin_message.Label
      reply_with_dev_message(reply_text_message("Your Location: #{@lx}, #{@ly}, #{@scale}, #{@label}"))
    end

    # <PicUrl><![CDATA[this is a url]]></PicUrl>
    # <MediaId><![CDATA[media_id]]></MediaId>
    def response_image_message
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      @pic_url  = @weixin_message.PicUrl  # 也可以直接通过此链接下载图片, 建议使用carrierwave.
      reply_with_dev_message(generate_image(@media_id))
    end

    # <Title><![CDATA[公众平台官网链接]]></Title>
    # <Description><![CDATA[公众平台官网链接]]></Description>
    # <Url><![CDATA[url]]></Url>
    def response_link_message
      @title = @weixin_message.Title
      @desc  = @weixin_message.Description
      @url   = @weixin_message.Url
      reply_with_dev_message(reply_text_message("回复链接信息"))
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <Format><![CDATA[Format]]></Format>
    def response_voice_message
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      @format   = @weixin_message.Format
      # 如果开启了语音翻译功能，@keyword则为翻译的结果
      # reply_text_message("回复语音信息: #{@keyword}")
      reply_with_dev_message(generate_voice(@media_id))
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <ThumbMediaId><![CDATA[thumb_media_id]]></ThumbMediaId>
    def response_video_message
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      # 视频消息缩略图的媒体id，可以调用多媒体文件下载接口拉取数据。
      @thumb_media_id = @weixin_message.ThumbMediaId
      reply_with_dev_message(reply_text_message("回复视频信息"))
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <ThumbMediaId><![CDATA[thumb_media_id]]></ThumbMediaId>
    def response_shortvideo_message
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      # 视频消息缩略图的媒体id，可以调用多媒体文件下载接口拉取数据。
      @thumb_media_id = @weixin_message.ThumbMediaId
      reply_with_dev_message(reply_text_message("回复短视频信息"))
    end

    def response_event_message
      event_type = @weixin_message.Event
      case event_type.downcase
      when 'unsubscribe'
        @weixin_public_account.user_accounts.where(uid: @weixin_message.FromUserName).limit(1).update_all(subscribed: false)
      when 'subscribe'
        @weixin_public_account.user_accounts.where(uid: @weixin_message.FromUserName).limit(1).update_all(subscribed: true)
      end
      send("handle_#{event_type.downcase}_event")
    end

    # 关注公众账号
    def handle_subscribe_event
      if @keyword.present?
        # 扫描带参数二维码事件: 1. 用户未关注时，进行关注后的事件推送
        return reply_with_dev_message(reply_text_message("扫描带参数二维码事件: 1. 用户未关注时，进行关注后的事件推送, keyword: #{@keyword}"))
      end
      reply_with_dev_message(reply_text_message("关注公众账号"))
    end

    # 取消关注
    def handle_unsubscribe_event
      Rails.logger.info("取消关注")
      NO_CONTENT
    end

    # 扫描带参数二维码事件: 2. 用户已关注时的事件推送
    def handle_scan_event
      reply_with_dev_message(reply_text_message("扫描带参数二维码事件: 2. 用户已关注时的事件推送, keyword: #{@keyword}"))
    end

    def handle_location_event # 上报地理位置事件
      @lat = @weixin_message.Latitude
      @lgt = @weixin_message.Longitude
      @precision = @weixin_message.Precision
      reply_with_dev_message(reply_text_message("Your Location: #{@lat}, #{@lgt}, #{@precision}"))
    end

    # 点击菜单拉取消息时的事件推送
    def handle_click_event
      key_event = find_key_event(@keyword)
      if key_event
        key_event.execute(self)
      else
        reply_with_dev_message(reply_text_message("你点击了: #{@keyword}"))
      end
    end

    # 点击菜单跳转链接时的事件推送
    def handle_view_event
      Rails.logger.info("你点击了: #{@keyword}")
      NO_CONTENT
    end

    # 弹出系统拍照发图
    def handle_pic_sysphoto_event
      NO_CONTENT
    end

    # 弹出拍照或者相册发图的事件推送
    def handle_pic_photo_or_album_event
      NO_CONTENT
    end

    # 扫码事件
    def handle_scancode_push_event
      NO_CONTENT
    end

    # 帮助文档: https://github.com/lanrion/weixin_authorize/issues/22

    # 由于群发任务提交后，群发任务可能在一定时间后才完成，因此，群发接口调用时，仅会给出群发任务是否提交成功的提示，若群发任务提交成功，则在群发任务结束时，会向开发者在公众平台填写的开发者URL（callback URL）推送事件。

    # 推送的XML结构如下（发送成功时）：

    # <xml>
    # <ToUserName><![CDATA[gh_3e8adccde292]]></ToUserName>
    # <FromUserName><![CDATA[oR5Gjjl_eiZoUpGozMo7dbBJ362A]]></FromUserName>
    # <CreateTime>1394524295</CreateTime>
    # <MsgType><![CDATA[event]]></MsgType>
    # <Event><![CDATA[MASSSENDJOBFINISH]]></Event>
    # <MsgID>1988</MsgID>
    # <Status><![CDATA[sendsuccess]]></Status>
    # <TotalCount>100</TotalCount>
    # <FilterCount>80</FilterCount>
    # <SentCount>75</SentCount>
    # <ErrorCount>5</ErrorCount>
    # </xml>
    def handle_masssendjobfinish_event
      Rails.logger.info("回调事件处理")
      NO_CONTENT
    end

    def handle_templatesendjobfinish_event
      Rails.logger.info("回调模板任务")
      NO_CONTENT
    end

    def reply_with_dev_message(msg)
      Rails.env.development? ? msg : NO_CONTENT
    end
  end
end
