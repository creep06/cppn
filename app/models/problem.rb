require 'net/http'

class Problem < ApplicationRecord
    belongs_to :user
end
