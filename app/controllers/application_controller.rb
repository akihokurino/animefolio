class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception
  	before_action :set_headers
	skip_before_action :verify_authenticity_token

	def cors_preflight_check
		head :no_content
	end

  	private
  	def set_headers
		origin_regex = Regexp.new(Settings.cors.origin_regex, Regexp::IGNORECASE)
		if request.headers["HTTP_ORIGIN"] && origin_regex.match(request.headers["HTTP_ORIGIN"])
			headers['Access-Control-Allow-Origin'] = request.headers["HTTP_ORIGIN"]
			Settings.cors[Rails.env.to_s].headers.each { |k, v| headers[k.to_s] = v }
		end
	end
end
