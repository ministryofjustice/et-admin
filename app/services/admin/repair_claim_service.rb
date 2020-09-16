module Admin
  class RepairClaimService
    def self.call(claim_id, base_url: ENV.fetch('ET_API_URL'))
      new(claim_id, base_url: base_url).call
    end

    def initialize(claim_id, base_url:)
      @claim_id = claim_id
      @base_url = base_url
    end

    def call
      self.response = HTTParty.post("#{base_url}/v2/claims/repair_claim",
                                    headers: {
                                      'Accept': 'application/json',
                                      'Content-Type': 'application/json'
                                    },
                                    body: {
                                      uuid: SecureRandom.uuid,
                                      command: 'RepairClaim',
                                      data: {
                                        claim_id: claim_id
                                      },
                                      async: false
                                    }.to_json)
      self
    end

    def valid?
      response.success?
    end

    private

    attr_reader :claim_id, :base_url
    attr_accessor :response
  end
end
