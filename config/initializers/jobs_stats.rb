total_job_count = 0
custom_threads  = []

ActiveSupport::Notifications.subscribe "enqueue.active_job" do |name, started, finished, unique_id, data|
  # Rails.logger.info "#{name} Received! (started: #{started}, finished: #{finished})" # process_action.action_controller Received (started: 2019-05-05 13:43:57 -0800, finished: 2019-05-05 13:43:58 -0800)
  total_job_count += 1
end

puts "Creating job stats thread"

custom_threads << Thread.new do |j|
    loop do
        sleep(1)
        puts "Total job count #{total_job_count}"
    end
end
