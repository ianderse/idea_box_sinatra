require 'redis'
require 'json'

$redis = Redis.new
require_relative './idea_box'

begin
  puts "You're listening to IdeaBox."
  puts "Press Ctrl-C at any time to exit.\n"
  $redis.subscribe(:community) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      IdeaStore.create(data['idea'])
      puts "#{data['idea']['title']}"
    end
  end
rescue Interrupt => e
  puts 'Goodbye...'
end
