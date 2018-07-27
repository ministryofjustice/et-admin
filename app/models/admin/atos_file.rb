require 'httparty'
module Admin
  class AtosFile
    class AtosFileProxy
      include Enumerable
      def initialize
        self._page_size = 25
        self._current_page = 1
        self.username = Rails.configuration.et_atos_api.username
        self.password = Rails.configuration.et_atos_api.password
      end

      def each(&block)
        file_names.each(&block)
      end

      def except(*args)
        self
      end

      def group_values
        []
      end

      def total_pages
        1
      end

      def current_page
        1
      end

      def limit_value
        _page_size
      end

      def total_count
        count
      end

      private

      def base_url
        ENV.fetch('ATOS_API_URL')
      end

      def file_names
        @response ||= begin
          response = HTTParty.get("#{base_url}/list", basic_auth: { username: username, password: password })
          response.body.lines.reverse.map do |line|
            AtosFile.new(id: line.strip)
          end
        end

      end

      attr_accessor :_page_size, :_current_page, :username, :password
    end
    include ActiveModel::Model

    attr_accessor :id

    def self.columns
      []
    end

    def self.primary_key
      :id
    end

    def self.all
      AtosFileProxy.new
    end

    def self.find(id)
      all.find {|r| r.id == id}
    end

    def self.base_class
      self
    end

    def base_url
      ENV.fetch('ATOS_API_URL')
    end

    def download(to:)
      HTTParty.get("#{base_url}/download/#{id}", basic_auth: { username: Rails.configuration.et_atos_api.username, password: Rails.configuration.et_atos_api.password }) do |chunk|
        to.write(chunk)
      end
    end
  end
end
