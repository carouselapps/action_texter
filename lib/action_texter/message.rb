# encoding: UTF-8
# Copyright © 2012, 2013, 2014, 2015, Carousel Apps

# Representation of a message
#
# TODO: Implement these fields that Nexmo can use: :status_report_req, :network_code, :vcard, :vcal, :ttl
#
# @!attribute from
#   @return [String] name or phone number of the author of the message.
# @!attribute to
#   @return [String] phone number of the author of the message.
# @!attribute text
#   @return [String] actual message to send.
# @!attribute reference
#   @return [String] a reference that can be used later on to track responses. Implemented for: Nexmo.
class ActionTexter::Message
  attr_accessor :from, :to, :text, :reference

  def initialize(message = {})
    self.from = message[:from] || raise("A message must contain from")
    self.to = message[:to] || raise("A message must contain to")
    self.text = message[:text] || raise("A message must contain text")
    self.reference = message[:reference]
  end

  def deliver(client = nil)
    message = ActionTexter.inform_interceptors(self)
    return nil if message.blank? # Do not send if one of the interceptors cancelled

    client ||= ActionTexter::Client.default
    if client.nil?
      raise "To deliver a message you need to specify a client by parameter to deliver or by ActionTexter::Client.dafault="
    end

    response = client.deliver(message)
    ActionTexter.inform_observers(message, response)
    response
  end

  # @private
  def to_s
    "#<#{self.class.name}:#{from}:#{to}:#{text}>"
  end
end
