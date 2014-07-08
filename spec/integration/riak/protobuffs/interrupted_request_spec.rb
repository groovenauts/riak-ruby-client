require 'spec_helper'
require 'timeout'

describe 'Protocol Buffers', test_client: true do
  describe 'interrupted requests' do

    let(:bucket){ random_bucket 'interrupted_requests' }
    
    before do
      first = bucket.new 'first'
      first.raw_data = 'first'
      first.store

      second = bucket.new 'second'
      second.raw_data = 'second'
      second.store
    end

    it 'fails out when a request is interrupted, and never returns the wrong payload' do
      expect do
        Timeout.timeout 1 do
          loop do
            expect(bucket.get('first')).to eq 'first'
          end
        end
      end.to raise_error Timeout::Error

      second = bucket.get 'second'
      expect(second.raw_data).to eq 'second'
    end    
  end
end
