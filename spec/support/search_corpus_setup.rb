# encoding: utf-8
shared_context "search corpus setup" do
  before do
    @search_bucket = random_bucket 'search_test'
    @backend.create_search_index @search_bucket.name
    @search_bucket.props = {search_index: @search_bucket.name}
    idx = 0
    old_encoding = Encoding.default_external
    Encoding.default_external = Encoding::UTF_8
    IO.foreach("spec/fixtures/munchausen.txt") do |para|
      next if para =~ /^\s*$|introduction|chapter/ui
      idx += 1
      Riak::RObject.new(@search_bucket, "munchausen-#{idx}") do |obj|
        obj.content_type = 'text/plain'
        obj.raw_data = para
        @backend.store_object(obj)
      end
    end

    Encoding.default_external = old_encoding
    sleep 1
  end
end
