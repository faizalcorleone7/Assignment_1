require 'openssl'

module ExpirationChecker

  def check_expiration(certificate)
    cert = OpenSSL::X509::Certificate.new(certificate)
    if cert.not_after.to_i - Time.now.to_i > 0
      "Certificate Not Expired"
    else
      "Certificate Expired"
    end
  end

end
