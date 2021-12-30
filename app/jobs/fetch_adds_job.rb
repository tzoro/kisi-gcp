require "google/cloud"
require "google/cloud/pubsub"

#Module here till writing code, easier to work, then separate in files

module ActiveJob
  module QueueAdapters
    class GcpAdapter < ActiveJob::QueueAdapters::AsyncAdapter

      keyfile = "gkey.json"
      gcp_id  = "awesome-beaker-336608"
      @@g_queue_name = "queue-1"

      creds = Google::Cloud::PubSub::Credentials.new keyfile
      @@pubsub = Google::Cloud::PubSub.new(
        project_id: gcp_id,
        credentials: creds
      )

      def initialize(**executor_options)
        @scheduler = Scheduler.new(**executor_options)
      end

      def enqueue(job) #:nodoc:

        job_name  = @@g_queue_name
        topic     = @@pubsub.topic job_name

        if topic.nil?
          topic = @@pubsub.create_topic job_name
        end

        sub_name      = job_name + "-subscription"
        subscription  = topic.subscription sub_name

        if subscription.nil?
          topic.subscribe sub_name
        end

        topic.publish job.class.name

        @scheduler.enqueue JobWrapper.new(job), queue_name: job.queue_name
      end

    end
  end
end

class FetchAddsJob < ApplicationJob
  queue_as :default
  self.queue_adapter = :gcp

  def perform(*args)
    # Do something later
  end
end

# begin
#   topic.publish_async "This is a test message." do |result|
#     raise "Failed to publish the message." unless result.succeeded?
#     puts "Message published asynchronously."
#   end

#   # Stop the async_publisher to send all queued messages immediately.
#   topic.async_publisher.stop.wait!
# rescue StandardError => e
#   puts "Received error while publishing: #{e.message}"
# end