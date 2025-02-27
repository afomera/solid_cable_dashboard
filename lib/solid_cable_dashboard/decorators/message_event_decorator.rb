module SolidCableDashboard
  module Decorators
    class MessageEventDecorator
      attr_reader :event

      def initialize(event)
        @event = event
      end

      def event_type
        event.event_type
      end

      def channel
        if event.channel.present?
          begin
            event.channel
          rescue
            "Binary channel"
          end
        else
          "Unknown"
        end
      end

      def channel_hash
        event.channel_hash
      end

      def byte_size
        event.byte_size
      end

      def human_byte_size
        return "N/A" unless event.byte_size
        ActiveSupport::NumberHelper.number_to_human_size(event.byte_size)
      end

      def duration
        event.duration
      end

      def human_duration
        return "N/A" unless event.duration
        "#{event.duration.round(2)} sec"
      end

      def created_at
        event.created_at
      end

      def created_ago
        time_ago_in_words(created_at) + " ago"
      end

      def status_badge
        case event_type.to_sym
        when SolidCableDashboard::MessageEvent::BROADCAST
          "broadcast bg-sky-100 text-sky-800 dark:bg-sky-900 dark:text-sky-300"
        when SolidCableDashboard::MessageEvent::RECEIVE
          "receive bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300"
        when SolidCableDashboard::MessageEvent::SUBSCRIBE
          "subscribe bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-300"
        when SolidCableDashboard::MessageEvent::UNSUBSCRIBE
          "unsubscribe bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300"
        else
          "unknown bg-zinc-100 text-zinc-800 dark:bg-zinc-900 dark:text-zinc-300"
        end
      end

      def method_missing(method, *args, &block)
        if event.respond_to?(method)
          event.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        event.respond_to?(method, include_private) || super
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
