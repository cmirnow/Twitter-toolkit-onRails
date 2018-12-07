class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  use_growlyflash
end
