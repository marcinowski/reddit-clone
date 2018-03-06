class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include SubsHelper
  include UserPermissionsHelper
end
