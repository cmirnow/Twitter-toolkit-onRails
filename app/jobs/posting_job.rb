class PostingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[1])

    args[0].each do |i|
      client.update(i)
      puts 'Posted: ' + i
      sleep rand(10..45)
    end
  end
end
