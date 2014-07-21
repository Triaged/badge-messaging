require 'thread'
require 'singleton'
 
class Emlogger
  include Singleton
  
  def initialize
    STDOUT.sync = true
    @queue = ::Queue.new
    create_thread
  end
  
  def log(message)
    @queue << message
  end
  
  def close
    @queue << SHUTDOWN_MESSAGE
  end
  
  private
  SHUTDOWN_MESSAGE = :SHUTDOWN
  
  def create_thread
    @thread = Thread.new(@queue) do |queue|
      begin
        message = queue.pop
        puts message unless message == SHUTDOWN_MESSAGE
      end until message == SHUTDOWN_MESSAGE
    end
  end
end