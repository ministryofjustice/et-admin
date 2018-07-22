class SetActionMailerHost
  def initialize(app)
    self.app = app
  end

  def call(env)
    ActionMailer::Base.default_url_options = { host: env['HTTP_HOST'] }
    app.call(env)

  end
  private

  attr_accessor :app
end
