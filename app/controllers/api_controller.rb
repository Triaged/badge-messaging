class ApiController < ApplicationController
	respond_to :json
  protect_from_forgery with: :null_session
  before_filter :authenticate_from_token!, :except => [:page_not_found]
  before_filter :current_user
  
  protected

  def page_not_found
    render :json => { :errors => ['Page not found'] }, :status => 404
  end

  def authenticate_from_token!
  	user_id = request.headers["HTTP_USER_ID"].presence
    auth_token = request.headers["HTTP_AUTHORIZATION"].presence
    unless auth_token && user_id && (User.find(user_id).valid_auth_token?(auth_token))
      render :json => { :errors => ['You must be signed in to access this page'] }, :status => 401
    end
  rescue
    # find_by fails with an invalid token
    render :json => { :errors => ['You must be signed in to access this page'] }, :status => 401
  end

  def current_user
    user_id = request.headers["User-Id"].presence
    User.find(user_id)
  end

end
