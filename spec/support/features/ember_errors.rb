module EmberErrors
  def ignoring_ember_errors
    page.execute_script('window._previous_logger_error = Ember.Logger.error')
    page.execute_script('Ember.Logger.error = Ember.K')
    yield
    page.execute_script('Ember.Logger.error = window._previous_logger_error')
    page.execute_script('delete window._previous_logger_error')
  end
end
