require 'comm/version'
require 'bunny'
require 'yajl'

module Comm
  class Base
    def encode data
      Yajl::Encoder.encode data
    end

    def decode data
      Yajl::Parser.parse data
    end

    def initialize *arg
      if ENV['AMQP_URL'].nil?
        @bunny = Bunny.new
      else
        @bunny = Bunny.new ENV['AMQP_URL']
      end

      @bunny.start
      @exchange = @bunny.exchange exchange_name, :type => :headers
    end

    def exchange_name
      'events_exchange'
    end 

    def queue_name
      ''
    end

    def finalize
      @bunny.stop
    end
  end

  class Consumer < Base
    def initialize types = nil 
      super
      @types = types
      @queue = @bunny.queue queue_name, :durable => true, :auto_delete => true
      @queue.bind @exchange
    end

    def subscribe
      @queue.subscribe do |headers, payload|
        if @types.nil? or @types.include? headers[:delivery_details][:routing_key]
          yield headers[:delivery_details][:routing_key], decode(headers[:payload])
        end
      end
    end
  end

  class Producer < Base
    def initialize *args
      super(*args)
    end

    def publish message, topic = 'unknown'
      @exchange.publish encode(message), :key => topic
    end
  end
end
