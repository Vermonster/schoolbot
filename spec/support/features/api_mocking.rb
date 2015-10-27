module APIMocking
  def mock_api_failure(controller_name, method_name)
    # Choose an error that will be rescued and return a non-successful status
    error = ActiveRecord::RecordNotFound
    controller = "API::#{controller_name.to_s.camelize}Controller".constantize
    allow_any_instance_of(controller).to receive(method_name).and_raise(error)
  end

  def unmock_api_failure(controller_name, method_name)
    controller = "API::#{controller_name.to_s.camelize}Controller".constantize
    allow_any_instance_of(controller).to receive(method_name).and_call_original
  end
end
