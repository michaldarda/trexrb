require 'spec_helper'

describe "Trexrb functional spec" do
  let(:backend) { Trexrb::Backend.new }

  it "is empty when started" do
    expect(backend.store.keys).to eq([])
  end

  it "doesn't fail when accessing missing key" do
    expect(backend.store[:foo]).to eq(nil)
  end

  it "sets key to value" do
    expect do
      backend.store["foo"] = "bar"
    end.to change { backend.store["foo"] }.from(nil).to("bar")
  end

  it "list all available keys" do
    backend.store["foo"] = "bar"
    backend.store["goo"] = "bazinga"

    expect(backend.store.keys).to eq("foo,goo")
  end
end
