require 'rspec'
require 'test_connection.rb'
require 'byebug'

describe TestConnection do

  context "Checking with no of bits" do

    it "should give error if no of bits are less than 512" do
      no = (rand() * 512).to_i
      start_time = Time.now.strftime("%Y-%m-%d")
      test_connection = TestConnection.new.get_certificate(no, start_time)
      expect(test_connection).to eq("Please give no of bits greater than or equal to 512")
    end

    it "should not give error if no of bits are greater than 512" do
      no = 2048
      start_time = "2021-04-14"
      test_connection = TestConnection.new.get_certificate(no, start_time)
      expect(test_connection).to eq("Certificate generated successfully")
    end

    it "should not give error if no of bits are equal to 512" do
      no = 512
      start_time = "2021-04-14"
      test_connection = TestConnection.new.get_certificate(no, start_time)
      expect(test_connection).to eq("Certificate generated successfully")
    end

    it "should not give error if no of bits are greater than 512 and not power of 2" do
      no = 1827
      start_time = "2021-04-14"
      test_connection = TestConnection.new.get_certificate(no, start_time)
      expect(test_connection).to eq("Certificate generated successfully")
    end

  end

  context "Checking expiry date" do

    it 'should give "Certificate Not Expired" for non-expired certificate' do
      no = 2048
      start_time = Time.now.strftime("%Y-%m-%d")
      test_connection = TestConnection.new
      test_connection.get_certificate(no, start_time)
      expiration_status = test_connection.check_expiration
      expect(expiration_status).to eq("Certificate Not Expired")
    end

    it 'should give "Certificate Expired" for expired certificate' do
      no = 2048
      start_time = (Time.at(Time.now.to_i - 2*365*24*60*60)).strftime("%Y-%m-%d")
      test_connection = TestConnection.new
      test_connection.get_certificate(no, start_time)
      expiration_status = test_connection.check_expiration
      expect(expiration_status).to eq("Certificate Expired")
    end

  end

end
