require "google/cloud"
require "google/cloud/pubsub"
require "#{Rails.root}/lib/active_job/queue_adapters/gcp_adapter"

class FetchAddsJob < ApplicationJob
  queue_as :default
  self.queue_adapter = :gcp

  fallback_wait_time = 5.minutes
  fallback_attempts  = 2

  retry_on ActiveRecord::Deadlocked, wait: fallback_wait_time, attempts: fallback_attempts
  retry_on Net::OpenTimeout, Timeout::Error, wait: fallback_wait_time, attempts: fallback_attempts

  def perform(*args)
    # Do something later
    puts "DOING JOOOOOB"
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