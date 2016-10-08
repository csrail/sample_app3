class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def csrail_landing
    render html: "Hello World!"
  end
end
