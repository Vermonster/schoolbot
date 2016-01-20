Paperclip::Attachment.default_options.merge!(
  path: "#{Rails.env}/:class/:attachment/:id/:style/:filename",
  storage: :s3,
  s3_protocol: :https,
  s3_credentials: {
    bucket: ENV.fetch('AWS_BUCKET'),
    access_key_id: ENV.fetch('AWS_ACCESS_KEY'),
    secret_access_key: ENV.fetch('AWS_SECRET_KEY')
  }
)
