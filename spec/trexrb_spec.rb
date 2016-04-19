require 'spec_helper'

describe "Trexrb functional spec" do
  let(:backend) { Trexrb::Backend.new }

  it "returns empty list of keys when is empty" do
    mock_socket

    expect(backend.store.keys).to eq([])
  end

  it "doesn't fail when accessing missing key" do
    mock_socket

    expect(backend.store[:foo]).to eq(nil)
  end

  it "sets key to value" do
    mock_socket "OK\r\n"

    expect(backend.store["foo"] = "bar").to eq "bar"
  end

  it "gets single key" do
    mock_socket "bar\r\n"

    expect(backend.store["foo"]).to eq "bar"
  end

  it "lists all available keys" do
    mock_socket("foo,goo\r\n")

    expect(backend.store.keys).to eq("foo,goo")
  end

  private

  def mock_socket(response = "\r\n")
    fake_socket = double().tap do |fake_socket|
      expect(fake_socket).to receive(:close_write)
      expect(fake_socket).to receive(:print)
      expect(fake_socket).to receive(:read)
        .and_return(response)
    end

    expect(Socket).to receive(:tcp).with('localhost', 4040)
      .and_return(fake_socket)
  end
end
