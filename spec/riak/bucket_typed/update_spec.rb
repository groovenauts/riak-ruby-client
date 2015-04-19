require 'spec_helper'
require 'riak/bucket_typed/bucket'

describe Riak::BucketTyped::Bucket, test_client: true do
  let(:client){ test_client }
  let(:key1){ "key1" }
  let(:data1){ [1,2,3] }
  let(:data2){ [1,2,3,4] }

  before do
    @bucket_type1 = client.bucket_type("bucket_type1")
    bucket1 = @bucket_type1.bucket("bucket1")
    begin
      bucket1.keys.each{|key| bucket1.delete(key)}
    rescue => e
      raise unless e.message =~ /No bucket-type named 'bucket_type1'/
    end
    @bucket1 = @bucket_type1.bucket("bucket1")
    @robject1 = @bucket1.new(key1)
    @robject1.data = data1
    @robject1.store # failed to store because @bucket_typ1 is not activated
  end

  it "get stored object" do
    obj = @bucket1.get(key1)
    expect(obj.data).to eq data1
  end

  it "get and update" do
    obj1 = @bucket1.get(key1)
    obj1.data = data2
    obj1.store
    
    obj2 = @bucket1.get(key1)
    expect(obj2.data).to eq data2
    expect(obj2.bucket.type).to eq @bucket1.type
  end

end
