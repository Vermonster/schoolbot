require 'rails_helper'

describe Zonar do
  describe '#bus_events_since' do
    it 'logs errors as warnings if the breaker is closed' do
      allow(Rails.logger).to receive(:warn)
      allow(RestClient::Request).to receive(:execute).and_raise('bluh!')
      allow(CB2::Breaker).to receive(:new).and_return(
        CB2::Breaker.new(strategy: 'stub', allow: true)
      )

      zonar = Zonar.new(customer: 'test1234', username: 'a', password: 'b')
      events = zonar.bus_events_since(1.minute.ago)

      expect(events).to be_empty
      expect(Rails.logger).to have_received(:warn).with(
        'Zonar error for test1234: bluh!'
      )
    end

    it 'raises an error with the customer ID if the breaker is open' do
      allow(CB2::Breaker).to receive(:new).and_return(
        CB2::Breaker.new(strategy: 'stub', allow: false)
      )

      zonar = Zonar.new(customer: 'test1234', username: 'a', password: 'b')

      expect { zonar.bus_events_since(1.minute.ago) }
        .to raise_error(CB2::BreakerOpen, 'Zonar breaker open: test1234')
    end
  end
end
