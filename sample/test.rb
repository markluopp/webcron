#!/usr/local/bin/ruby

# Usage
def usage
    puts "#{$0} need 3 parameters"
    exit 1
end

if ARGV.count != 2
    usage
end

begin
sleep 10
puts "Sex: #{ARGV[0]}"

sleep 10
puts "echoStr: #{ARGV[1]}"

# error handle
unknow_function()

sleep 10

rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
    exit 1
end
    
