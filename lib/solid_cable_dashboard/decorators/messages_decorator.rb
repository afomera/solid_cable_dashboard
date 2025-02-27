module SolidCableDashboard
  module Decorators
    class MessagesDecorator
      include Enumerable
      
      attr_reader :messages
      
      def initialize(messages)
        @messages = messages
      end
      
      def each(&block)
        messages.each do |message|
          yield SolidCableDashboard.decorate(message)
        end
      end
      
      def method_missing(method, *args, &block)
        if messages.respond_to?(method)
          messages.send(method, *args, &block)
        else
          super
        end
      end
      
      def respond_to_missing?(method, include_private = false)
        messages.respond_to?(method, include_private) || super
      end
    end
  end
end
