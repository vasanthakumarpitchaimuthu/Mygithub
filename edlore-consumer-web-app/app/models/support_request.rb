class SupportRequest < ActiveRecord::Base
  enum type: [ :email, :call]
end
