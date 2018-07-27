module Admin
  class AcasCertificateSearchService

    # @param [Admin::AcasCertificateForm] form The input form
    def self.call(form)
      if form.number.nil?
        form.certificate = AcasCertificate.nil_instance
        return
      end
      base_url = ENV.fetch('ACAS_API_URL')
      response = HTTParty.get("#{base_url}/certificates/#{form.number}", format: :json, headers: { 'EtUserId': form.current_admin_user.email, 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
      if response.code == 422
        form.errors.add :number, :invalid_certificate
      elsif response.code == 404
        form.errors.add :number, :not_found, number: form.number
      elsif response.code == 200
        form.certificate = AcasCertificate.new(response.parsed_response['data'])
      else
        form.errors.add :number, :unknown_exception
      end
      form.certificate = AcasCertificate.nil_instance unless form.errors.empty?
    end

  end
end
