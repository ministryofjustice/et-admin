module Admin
  class ExportClaimsService
    include ActiveModel::Model
    include ActiveModel::Attributes
    attribute :claim_ids
    attribute :external_system_id
    attribute :base_url
    def self.call(claim_ids, external_system_id, base_url: ENV.fetch('ET_API_URL'))
      new(claim_ids: claim_ids, external_system_id: external_system_id, base_url: base_url).call
    end

    def call
      response = HTTParty.post("#{base_url}/v2/exports/export_claims",
                               headers: {
                                   'Accept': 'application/json',
                                   'Content-Type': 'application/json'
                               },
                               body: {
                                   uuid: SecureRandom.uuid,
                                   command: 'ExportClaims',
                                   data: {
                                       claim_ids: claim_ids,
                                       external_system_id: external_system_id
                                   },
                                   async: false
                               }.to_json)
      return self if response.success?

      if response['errors']
        response['errors'].each do |err|
          errors.add err['source'].gsub(/\A\//, '').to_sym, err['detail'], error: err['code']
        end
      else
        errors.add :base, :http_error, status_code: response.code.to_s
      end
      self
    end
  end
end