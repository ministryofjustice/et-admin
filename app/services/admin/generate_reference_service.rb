module Admin
  class GenerateReferenceService
    def self.call(postcode, base_url: ENV.fetch('ET_API_URL'), into: Admin::GenerateReference.new)

      response = HTTParty.post("#{base_url}/v2/references/create_reference",
                               headers: {
                                 'Accept': 'application/json',
                                 'Content-Type': 'application/json'
                               },
                               body: {
                                 uuid: SecureRandom.uuid,
                                 command: 'CreateReference',
                                 data: {
                                   post_code: postcode
                                 },
                                 async: false
                               }.to_json)

      into.reference = response.parsed_response.dig("data", "reference")
      into
    end
  end
end
