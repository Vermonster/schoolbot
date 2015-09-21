require 'rails_helper'

describe Zonar do
  describe '#bus_events_since' do
    it 'raises an error with the customer ID if the breaker is open' do
      allow(CB2::Breaker).to receive(:new).and_return(
        CB2::Breaker.new(strategy: 'stub', allow: false)
      )

      zonar = Zonar.new(customer: 'test1234', username: 'a', password: 'b')

      expect { zonar.bus_events_since(1.minute.ago) }
        .to raise_error(CB2::BreakerOpen, 'Zonar customer: test1234')
    end
  end
end
