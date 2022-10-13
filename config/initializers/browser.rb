Rails.configuration.middleware.use Browser::Middleware do
    redirect_to unsupported_path unless browser.platform.windows? || browser.platform.mac? || browser.platform.linux?
  end