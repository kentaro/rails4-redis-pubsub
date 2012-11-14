module MyApp
  class Job
    attr_reader :id, :redis

    def initialize(id)
      @id    = id
      @redis = Redis.new(Settings.redis.to_hash)
    end

    # Emulating time-consuming job
    def run
      publish('start')
      1.upto(5) { |n| publish(n); sleep 1 }
      publish('close')
    end

    private

    def publish(message)
      redis.publish(id, message)
    end
  end
end
