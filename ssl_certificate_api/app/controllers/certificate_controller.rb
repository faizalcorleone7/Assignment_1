require 'CA/certificate_generator'

class CertificateController < ApplicationController

	include CA

	def generate_certificate
		begin
			render json: {certificate: CA::CertificateGenerator.new(derive_key_size, derive_start_time).generate}, status: :ok
		rescue => exception
			render json: {error_message: exception.message}, status: 500
		end
	end

	private

	def derive_key_size
		no_of_bits = params[:no_of_bits].to_i
		raise StandardError.new("Please give no of bits greater than or equal to 512") if no_of_bits < 512
		no_of_bits
	end

	def derive_start_time
		(params[:start_date_time] + " 00:00:00").to_datetime
	end

end
