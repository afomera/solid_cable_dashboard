# frozen_string_literal: true

require "active_support/notifications"
require "digest/md5"

module SolidCableDashboard
  module Instrumentation
    def self.install
      ActiveSupport::Notifications.subscribe("transmit_subscription_confirmation.action_cable") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        channel = event.payload[:channel_class].to_s
        channel_hash = channel_hash_for(channel)
        payload_size = event.payload[:payload]&.bytesize
        SolidCableDashboard::MessageEvent.create!(
          event_type: SolidCableDashboard::MessageEvent::SUBSCRIBE,
          channel: channel,
          channel_hash: channel_hash,
          byte_size: payload_size,
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end
      ActiveSupport::Notifications.subscribe("transmit_subscription_rejection.action_cable") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        channel = event.payload[:channel_class].to_s
        channel_hash = channel_hash_for(channel)
        payload_size = event.payload[:payload]&.bytesize
        SolidCableDashboard::MessageEvent.create!(
          event_type: SolidCableDashboard::MessageEvent::UNSUBSCRIBE,
          channel: channel,
          channel_hash: channel_hash,
          byte_size: payload_size,
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end

      # Standard ActionCable broadcast events
      ActiveSupport::Notifications.subscribe("broadcast.action_cable") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        
        # ActionCable uses :broadcasting instead of :channel
        channel = event.payload[:broadcasting].to_s
        channel_hash = channel_hash_for(channel)
        
        # Get the message size - it might be a complex object so convert to JSON if needed
        message = event.payload[:message]
        payload_size = if message.is_a?(String)
          message.bytesize
        else
          message.to_json.bytesize
        end

        SolidCableDashboard::MessageEvent.create!(
          event_type: SolidCableDashboard::MessageEvent::BROADCAST,
          channel: channel,
          channel_hash: channel_hash,
          byte_size: payload_size,
          payload: message,
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end

      ActiveSupport::Notifications.subscribe("transmit.action_cable") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        
        # ActionCable uses :broadcasting instead of :channel
        channel = event.payload[:broadcasting].to_s
        channel_hash = channel_hash_for(channel)
        
        # Get the message size - it might be a complex object so convert to JSON if needed
        message = event.payload[:message]
        payload_size = if message.is_a?(String)
          message.bytesize
        else
          message.to_json.bytesize
        end

        SolidCableDashboard::MessageEvent.create!(
          event_type: SolidCableDashboard::MessageEvent::BROADCAST,
          channel: channel,
          channel_hash: channel_hash,
          byte_size: payload_size,
          payload: message,
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end
    end

    private

    def self.extract_channel_from_event(event)
      if event.payload[:channel]
        event.payload[:channel].to_s
      elsif event.payload[:channel_class]
        event.payload[:channel_class].to_s
      else
        "Unknown Channel"
      end
    end

    def self.channel_hash_for(channel)
      # Generate a hash for the channel name
      # This replaces the dependency on SolidCable::Message.channel_hash_for
      Digest::MD5.hexdigest(channel)[0..15].to_i(16)
    end
  end
end
