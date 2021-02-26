module Admin
  class AssignClaimService
    include ActiveModel::Model
    include ActiveModel::Attributes
    attribute :claim_id
    attribute :office_id
    attribute :user_id
    attribute :base_url
    def self.call(claim_id:, office_id:, user_id:, base_url: ENV.fetch('ET_API_URL'))
      new(claim_id: claim_id, office_id: office_id, user_id: user_id, base_url: base_url).call
    end

    def valid?
      errors.empty?
    end

    def call
      response = HTTParty.post("#{base_url}/v2/claims/assign_claim",
                               headers: {
                                   'Accept': 'application/json',
                                   'Content-Type': 'application/json'
                               },
                               body: {
                                   uuid: SecureRandom.uuid,
                                   command: 'AssignClaim',
                                   data: {
                                       claim_id: claim_id,
                                       office_id: office_id,
                                       user_id: user_id
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
