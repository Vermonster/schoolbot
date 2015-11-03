Billy.configure do |config|
  config.whitelist += [/lvh\.me/]
  config.non_whitelisted_requests_disabled = true
end
