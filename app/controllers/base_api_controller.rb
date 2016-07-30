class BaseApiController < ApplicationController
  before_action :parse_request,  :authenticate

  private
    def parse_request
      @json = JSON.parse(request.body.read)
    end

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token("API") do |token, options|
        User.find_by(auth_token: @json["api_token"])
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: 'Bad credentials', status: 401
    end
end

