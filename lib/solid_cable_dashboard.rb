# frozen_string_literal: true

require "rails"
require "groupdate"
require "chartkick"
require_relative "solid_cable_dashboard/version"
require_relative "solid_cable_dashboard/configuration"
require_relative "solid_cable_dashboard/engine"
require_relative "solid_cable_dashboard/message"
require_relative "solid_cable_dashboard/instrumentation"
require_relative "solid_cable_dashboard/models/message_event"
require_relative "solid_cable_dashboard/decorators/message_decorator"
require_relative "solid_cable_dashboard/decorators/messages_decorator"
require_relative "solid_cable_dashboard/decorators/message_event_decorator"
require_relative "solid_cable_dashboard/decorators/message_events_decorator"

module SolidCableDashboard
  class Error < StandardError; end

  def self.messages
    SolidCable::Message.all
  end

  def self.decorate(object)
    case object
    when SolidCable::Message
      Decorators::MessageDecorator.new(object)
    when SolidCable::Message.const_get(:ActiveRecord_Relation)
      Decorators::MessagesDecorator.new(object)
    when SolidCableDashboard::MessageEvent
      Decorators::MessageEventDecorator.new(object)
    when SolidCableDashboard::MessageEvent.const_get(:ActiveRecord_Relation)
      Decorators::MessageEventsDecorator.new(object)
    else
      raise Error, "Cannot decorate #{object.class}"
    end
  end
end
