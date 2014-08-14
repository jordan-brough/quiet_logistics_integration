class Receiver
  attr_reader :sqs, :count

  def initialize(queue_name)
    @sqs = AWS::SQS.new
    @limit = 10
    @queue_name = queue_name
    @count = 0
  end

  def receive_messages
    queue = sqs.queues.named(@queue_name)

    queue.receive_message(limit: @limit) do |sqs_message|
      msg = Messages::MessageParser.parse(sqs_message)

      next if msg.empty?
      @count += 1

      yield(msg)
    end
  end
end