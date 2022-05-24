require 'openssl'

module CA

  class CertificateGenerator

    def initialize(key_size, start_date_time)
      @key_size = key_size
      @start_date_time = start_date_time
    end

    def generate
      generate_expiry_times
      set_keys
      set_certificate
      set_extensions
      sign_certificate
      self_signed_pem
    end

    private

    def generate_expiry_times
      @start_time = @start_date_time
      @expiry_time = @start_date_time + 1.year
    end

    def set_keys
      @key = OpenSSL::PKey::RSA.new(@key_size)
      @public_key = @key.public_key
    end

    def set_certificate
      subject = "/C=BE/O=Test/OU=Test/CN=Test"
      @cert = OpenSSL::X509::Certificate.new
      @cert.subject = @cert.issuer = OpenSSL::X509::Name.parse(subject)
      @cert.not_before = @start_time
      @cert.not_after = @expiry_time
      @cert.public_key = @public_key
      @cert.serial = 0x0
      @cert.version = 2
    end

    def set_extensions
      extension_factory = OpenSSL::X509::ExtensionFactory.new
      extension_factory.subject_certificate = @cert
      extension_factory.issuer_certificate = @cert
      @cert.extensions = [
          extension_factory.create_extension("basicConstraints","CA:TRUE", true),
          extension_factory.create_extension("subjectKeyIdentifier", "hash"),
      ]
      @cert.add_extension extension_factory.create_extension("authorityKeyIdentifier", "keyid:always,issuer:always")
    end

    def sign_certificate
      @cert.sign @key, OpenSSL::Digest::SHA1.new
    end

    def self_signed_pem
      @cert.to_pem
    end

  end

end
