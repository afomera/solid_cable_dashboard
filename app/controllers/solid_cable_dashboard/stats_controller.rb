module SolidCableDashboard
  class StatsController < ApplicationController
    def index
      @messages = SolidCableDashboard.decorate(SolidCable::Message.all)
      @messages_count = SolidCable::Message.count
      # Remove message size calculation since payload_size column doesn't exist
      @messages_size = 0
      @messages_human_size = "N/A"
      
      @message_events = SolidCableDashboard.decorate(SolidCableDashboard::MessageEvent.all)
      @broadcast_count = SolidCableDashboard::MessageEvent.broadcasts.count
      @receive_count = SolidCableDashboard::MessageEvent.receives.count
      @subscribe_count = SolidCableDashboard::MessageEvent.subscribes.count
      @unsubscribe_count = SolidCableDashboard::MessageEvent.unsubscribes.count
      
      # Use a rescue block to handle potential column issues
      begin
        @channels_count = SolidCable::Message.distinct.count(:channel_hash)
      rescue => e
        Rails.logger.error "Error counting channels: #{e.message}"
        @channels_count = 0
      end
    end
  end
end
