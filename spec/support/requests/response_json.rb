module ResponseJSON
  def response_json
    @response_json ||= JSON.parse(response.body).deep_symbolize_keys
  end
end
