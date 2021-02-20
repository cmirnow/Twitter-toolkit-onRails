class FollowHandsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    follow(args[0])
  end
end
