class StreamerController < ApplicationController
  include ActionController::Live

  def dequeue
    job_id = params[:job_id]
    response.headers['Content-Type'] = 'text/event-stream'

    redis = Redis.new(Settings.redis.to_hash)
    redis.subscribe(job_id) do |on|
      on.message do |channel, message|
        if message != 'close'
          push_event('message', message)
        else
          redis.unsubscribe
          push_event('close')
          response.stream.close
        end
      end
    end
  end

  private

  def push_event(event = nil, message = nil)
    event.present?   && response.stream.write("event: #{event}\n")
    message.present? && response.stream.write("data: #{message}\n")
    response.stream.write("\n")
  end
end
