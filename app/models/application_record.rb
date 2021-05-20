require 'net/http' # necessary for checking the existence of image url
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
