require 'httparty'
class AcasCertificate
  NIL_INSTANCE = new
  include ActiveModel::Model

  attr_accessor :id, :claimant_name, :respondent_name, :certificate_number, :date_of_issue, :date_of_receipt, :message, :method_of_issue, :certificate_base64

  def self.find(id, current_admin_user:)
    return nil_instance if id.nil?
    base_url = ENV.fetch('ACAS_API_URL')
    response = HTTParty.get("#{base_url}/certificates/#{id}", format: :json, headers: { 'EtUserId': current_admin_user.email, 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
    return nil_instance if response.code == 404
    return nil_instance if response.code == 422
    raise 'An error occured communicating with acas' unless (200..299).include?(response.code)
    AcasCertificate.new(response.parsed_response['data'])
  end

  def self.nil_instance
    NIL_INSTANCE
  end

  def base_url
    ENV.fetch('ATOS_API_URL')
  end

  def nil_instance?
    self === NIL_INSTANCE
  end

  def certificate_number=(v)
    @certificate_number = v
    @id = v
  end

  def date_of_issue=(d)
    @date_of_issue = case d
    when String then
      Time.zone.parse(d)
    else
      d
    end
  end

  def date_of_receipt=(d)
    @date_of_receipt = case d
    when String then
      Time.zone.parse(d)
    else
      d
    end
  end

  def download(to:)
    HTTParty.get("#{base_url}/v1/filetransfer/download/#{id}") do |chunk|
      to.write(chunk)
    end
  end
end
