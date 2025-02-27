module SolidCableDashboard
  class MessageEventsController < ApplicationController
    def index
      @message_events = SolidCableDashboard::MessageEvent.order(created_at: :desc)
      @pagy, @message_events = pagy(@message_events)
      @message_events = SolidCableDashboard.decorate(@message_events)
    end
  end
end
