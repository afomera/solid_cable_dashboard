module SolidCableDashboard
  module Decorators
    class MessageEventsDecorator
      include Enumerable
      
      attr_reader :events
      
      def initialize(events)
        @events = events
      end
      
      def each(&block)
        events.each do |event|
          yield SolidCableDashboard.decorate(event)
        end
      end
      
      def method_missing(method, *args, &block)
        if events.respond_to?(method)
          events.send(method, *args, &block)
        else
          super
        end
      end
      
      def respond_to_missing?(method, include_private = false)
        events.respond_to?(method, include_private) || super
      end
    end
  end
end
