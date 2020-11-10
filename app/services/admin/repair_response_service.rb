module Admin
  class RepairResponseService
    def self.call(response_id, base_url: ENV.fetch('ET_API_URL'))
      new(response_id, base_url: base_url).call
    end

    def initialize(response_id, base_url:)
      @response_id = response_id
      @base_url = base_url
    end

    def call
      self.response = HTTParty.post("#{base_url}/v2/respondents/repair_response",
                                    headers: {
                                      'Accept': 'application/json',
                                      'Content-Type': 'application/json'
                                    },
                                    body: {
                                      uuid: SecureRandom.uuid,
                                      command: 'RepairResponse',
                                      data: {
                                        response_id: response_id
                                      },
                                      async: false
                                    }.to_json)
      self
    end

    def valid?
      response.success?
    end

    private

    attr_reader :response_id, :base_url
    attr_accessor :response
  end
end
