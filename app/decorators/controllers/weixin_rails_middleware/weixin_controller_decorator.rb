# encoding: utf-8
# 1, @weixin_message: 获取微信所有参数.
# 2, @weixin_public_account: 如果配置了public_account_class选项,则会返回当前实例,否则返回nil.
# 3, @keyword: 目前微信只有这三种情况存在关键字: 文本消息, 事件推送, 接收语音识别结果
WeixinRailsMiddleware::WeixinController.class_eval do

  def reply
    Rails.logger.debug "========== Request ============"
    Rails.logger.debug
    Rails.logger.debug @weixin_message.inspect
    Rails.logger.debug
    Rails.logger.debug "@keyword = #{@keyword.inspect}"
    Rails.logger.debug
    Rails.logger.debug "==============================="

    response_data = @weixin_public_account.reply_weixin(@weixin_message, @keyword)

    Rails.logger.debug "========== Response ==========="
    Rails.logger.debug
    Rails.logger.debug response_data.inspect
    Rails.logger.debug
    Rails.logger.debug "==============================="

    if response_data == :no_content
      render text: 'success'
    else
      render xml: response_data
    end
  end

end
