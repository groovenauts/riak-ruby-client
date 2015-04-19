require 'spec_helper'
require 'riak/bucket_typed/bucket'

describe Riak::BucketTyped::Bucket do
  before(:all){ Riak::Client::BeefcakeProtobuffsBackend.configured? }

  let(:client_id){ Riak::Client::MAX_CLIENT_ID - 1 }
  let(:client){ Riak::Client.allocate }
  let(:type){ client.bucket_type 'type' }

  let(:key1){ "key1" }
  let(:data1){ [1,2,3] }
  let(:data2){ [1,2,3,4] }

  let(:node){ double(:node, host: "dummy1", pb_port: 10017) }
  let(:backend){ Riak::Client::BeefcakeProtobuffsBackend.new(client, node) }

  before do
    allow(client).to receive(:client_id).and_return(client_id)
    allow(client).to receive(:backend).and_yield(backend)
    expect(backend).to receive(:prune_unsupported_options).with(:PutReq, {:returnbody=>true, :type=>"bucket_type1", :return_body=>true}).
      and_return({:returnbody=>true, :type=>"bucket_type1", :return_body=>true})
    @bucket_type1 = client.bucket_type("bucket_type1")
    @bucket1 = @bucket_type1.bucket("bucket1")
  end

  it "get stored object" do
    expect(Riak::Client::BeefcakeProtobuffsBackend::RpbPutReq).to\
    receive(:new).with({}).and_call_original
    @robject1 = @bucket1.new(key1)
    @robject1.data = data1
    @robject1.store
  end

end
