class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def default_url_options
    { only_path: true }
  end

  def root_redirect
    redirect_to keys_path
  end

  def key_path(key)
    key = key.sub(/^\/+/, "")

    path = ENV["ETCDCTL_WEB_PREFIX"].to_s
    path += "/keys/#{key}"
    path += "?#{request.query_string}" if request.query_string.present?
    path = "/" + path unless path.starts_with?("/")
    path
  end

  helper_method :key_path

  def recursive_dirs_on
    session[:recursive_dirs] = true
    redirect_to :back
  end

  def recursive_dirs_off
    session[:recursive_dirs] = false
    redirect_to :back
  end

end
