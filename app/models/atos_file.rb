require 'httparty'
class AtosFile
  class AtosFileProxy
    include Enumerable
    def initialize(external_system:)
      self._page_size = 25
      self._current_page = 1
      self.username = external_system.config[:username]
      self.password = external_system.config[:password]
      self.external_system = external_system
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
          AtosFile.new(id: line.strip, external_system: external_system)
        end
      end

    end

    attr_accessor :_page_size, :_current_page, :username, :password, :external_system
  end
  include ActiveModel::Model

  attr_accessor :id, :external_system

  def self.columns
    []
  end

  def self.primary_key
    :id
  end

  def self.all(external_system:)
    AtosFileProxy.new(external_system: external_system)
  end

  def self.find(id, external_system:)
    all(external_system: external_system).find {|r| r.id == id}
  end

  def self.base_class
    self
  end

  def base_url
    ENV.fetch('ATOS_API_URL')
  end

  def download(to:)
    HTTParty.get("#{base_url}/download/#{id}", basic_auth: { username: external_system.config[:username], password: external_system.config[:password] }) do |chunk|
      to.write(chunk)
    end
  end
end
