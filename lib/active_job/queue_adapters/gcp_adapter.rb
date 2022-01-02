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
