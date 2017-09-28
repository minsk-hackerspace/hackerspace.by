class WikiGateway
  def self.call(env)
    sinatra_ip = '127.0.0.1'
    sinatra_port = 4567

    r = RestClient::Request.execute method: env['REQUEST_METHOD'],
                                    url: "http://#{sinatra_ip}:#{sinatra_port}#{env['REQUEST_URI']}",
                                    cookies: cookies(env['HTTP_COOKIE']),
                                    payload: env['rack.request.form_hash']

    headers = JSON.parse(JSON[r.headers])
    [r.code, headers, [r.body]]
  end

  def self.cookies(str)
    cookies = {}
    str.split('; ').each do |cookie_pair|
      k, v = cookie_pair.split('=')
      cookies[k] = v
    end
    cookies
  end
end