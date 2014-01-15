class ApplicationController < ActionController::Base

	before_filter :allow_cross_domain_access

	protect_from_forgery

 	helper_method :current_user

	private

	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

    def allow_cross_domain_access
	    response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, DELETE"
	    response.headers["Access-Control-Allow-Headers"] = "*"
	    response.headers['Access-Control-Allow-Origin'] = '*'
    end

end
