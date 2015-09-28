module DefaultLocale
  def t(key, options = {})
    super(key, { locale: :en }.merge(options))
  end
end
