require "rack"

class RackApp
  def call(env)
    req = Rack::Request.new(env)
    IO.copy_stream(req.body, "/uploads/#{req.path}")

    [204, {}, nil]
  end
end

run RackApp.new
