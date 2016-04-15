require 'spec_helper'

describe "Trexrb functional spec" do
  let(:client) { Trexrb.new }

  it "returns empty list of keys when is empty" do
    expect(Socket).to receive(:tcp).with('localhost', 4040)
      .and_return(fake_socket)

    expect(client.keys).to eq([])
  end

  it "doesn't fail when accessing missing key" do
    expect(Socket).to receive(:tcp).with('localhost', 4040)
      .and_return(fake_socket)

    expect(client[:foo]).to eq(nil)
  end

  it "sets key to value" do
    expect(Socket).to receive(:tcp).with('localhost', 4040)
      .and_return(fake_socket "OK\r\n")

    expect(client["foo"] = "bar").to eq "bar"
  end

  it "gets single key" do
    expect(Socket).to receive(:tcp).with('localhost', 4040)
      .and_return(fake_socket "bar\r\n")

    expect(client["foo"]).to eq "bar"
  end

  it "lists all available keys" do
    expect(Socket).to receive(:tcp).with('localhost', 4040)
      .and_return(fake_socket "foo,goo\r\n")

    expect(client.keys).to eq("foo,goo")
  end

  private

  def fake_socket(response = "\r\n")
    double().tap do |fake_socket|
      expect(fake_socket).to receive(:close_write)
      expect(fake_socket).to receive(:print)
      expect(fake_socket).to receive(:read)
        .and_return(response)
    end
  end
end
