class User < ActiveRecord::Base
  def is_doctor?
    self.doctor_id
  end
end
