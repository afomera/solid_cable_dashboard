module SolidCableDashboard
  class MessageEvent < ActiveRecord::Base
    # Types of message events
    BROADCAST = :broadcast
    RECEIVE = :receive
    SUBSCRIBE = :subscribe
    UNSUBSCRIBE = :unsubscribe
    
    EVENT_TYPES = [BROADCAST, RECEIVE, SUBSCRIBE, UNSUBSCRIBE]
    
    EVENT_COLORS = {
      BROADCAST => "sky",
      RECEIVE => "green",
      SUBSCRIBE => "amber",
      UNSUBSCRIBE => "red"
    }
    
    def self.event_color(event_type)
      EVENT_COLORS[event_type] || "zinc"
    end

    self.table_name = 'solid_cable_dashboard_events'

    scope :broadcasts, -> { where(event_type: SolidCableDashboard::MessageEvent::BROADCAST) }
    scope :receives, -> { where(event_type: SolidCableDashboard::MessageEvent::RECEIVE) }
    scope :subscribes, -> { where(event_type: SolidCableDashboard::MessageEvent::SUBSCRIBE) }
    scope :unsubscribes, -> { where(event_type: SolidCableDashboard::MessageEvent::UNSUBSCRIBE) }
    
    scope :recent, -> { order(created_at: :desc) }

    def broadcast?
      event_type.to_sym == SolidCableDashboard::MessageEvent::BROADCAST
    end

    def receive?
      event_type.to_sym == SolidCableDashboard::MessageEvent::RECEIVE
    end

    def subscribe?
      event_type.to_sym == SolidCableDashboard::MessageEvent::SUBSCRIBE
    end

    def unsubscribe?
      event_type.to_sym == SolidCableDashboard::MessageEvent::UNSUBSCRIBE
    end

    def color
      SolidCableDashboard::MessageEvent.event_color(event_type.to_sym)
    end
  end
end
