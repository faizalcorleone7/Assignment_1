require 'byebug'
require './expiry_checker_modules/data_fetcher.rb'
require './expiry_checker_modules/check_expiration.rb'

include DataFetcher
include ExpirationChecker

class TestConnection

  def check_expiration
    ExpirationChecker.check_expiration(@certificate)
  end

  def get_certificate(no_of_bits=2048, start_date_time)
    begin
      @certificate = DataFetcher::CARestAPIQuery.new(no_of_bits, start_date_time).get_data["certificate"]
      save_cert(@certificate)
      "Certificate generated successfully"
    rescue RestClient::ExceptionWithResponse => error
      JSON.parse(error.response.body)["error_message"]
    rescue => e
      e.message
    end
  end

  private

  def save_cert(certificate)
    directory_name = "PEM Files"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    File.open("PEM Files/#{timestamp}.pem", "w") { | file | file.write(certificate) }
  end

  def timestamp
    Time.now.strftime("%Y_%m_%d_%k_%M_%S")
  end

end
