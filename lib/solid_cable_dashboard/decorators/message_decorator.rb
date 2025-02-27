module SolidCableDashboard
  module Decorators
    class MessageDecorator
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def id
        message.id
      end

      def channel
        message.channel
      rescue
        "Binary channel (#{message.channel.bytesize} bytes)"
      end

      def payload
        truncated_payload = message.payload[0..100]
        truncated_payload << "..." if message.payload.bytesize > 100
        truncated_payload
      rescue
        "Binary payload (#{message.payload.bytesize} bytes)"
      end

      def payload_size
        message.payload.bytesize
      end

      def human_payload_size
        ActiveSupport::NumberHelper.number_to_human_size(payload_size)
      end

      def created_at
        message.created_at
      end

      def created_ago
        time_ago_in_words(created_at) + " ago"
      end

      def method_missing(method, *args, &block)
        if message.respond_to?(method)
          message.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        message.respond_to?(method, include_private) || super
      end

      private

      def time_ago_in_words(time)
        distance_in_seconds = (Time.current - time).round
        
        case distance_in_seconds
        when 0..59
          "#{distance_in_seconds} seconds"
        when 60..3599
          "#{(distance_in_seconds / 60).round} minutes"
        when 3600..86399
          "#{(distance_in_seconds / 3600).round} hours"
        else
          "#{(distance_in_seconds / 86400).round} days"
        end
      end
    end
  end
end
