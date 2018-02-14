module SessionsHelper
  def log_in(user)
    logger.info "Logging user " + user.email + "with id " + user.id.to_s
    session[:user_id] = user.id
    logger.info "Session user_id key: " + session[:user_id].to_s
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
