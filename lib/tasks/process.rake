namespace :process do
  desc "TODO"

  require "google/cloud"
  require "google/cloud/pubsub"

  task gcp: :environment do
    keyfile = "gkey.json"
    project_id = "awesome-beaker-336608"
    creds = Google::Cloud::PubSub::Credentials.new keyfile
    pubsub = Google::Cloud::PubSub.new(
      project_id: project_id,
      credentials: creds
    )

    pubsub.topics.each do |topic|

      topic_name_val  = topic.name
      topic_name      = topic_name_val.gsub 'projects/' + project_id + '/topics/' , ''

      subscription      = pubsub.subscription topic_name + "-subscription"
      received_messages = subscription.pull immediate: false, max: 10

      received_messages.each do |msg|
        puts msg.inspect
        # msg.acknowledge!
      end
    end
  end

end
