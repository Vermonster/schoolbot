module JSONRequests
  %w(head get post put patch delete).each do |method_name|
    define_method(method_name) do |path, params = {}, headers = {}|
      super(path, params.to_json, default_headers.merge(headers))
    end
  end

  def default_headers
    {
      'CONTENT_TYPE' => 'application/json',
      accept: 'application/json'
    }
  end
end
