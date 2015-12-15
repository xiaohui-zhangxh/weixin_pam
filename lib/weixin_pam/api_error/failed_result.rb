module WeixinPam
  module ApiError
    class FailedResult < StandardError
      attr_reader :result
      def initialize(result, message)
        @result = result
        super(message)
      end
    end
  end
end
