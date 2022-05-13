class SuspendUsersService
  attr_reader :debitors

  def initialize
  end

  def set_users_as_suspended
    debitors = User.fee_expires_in(0.days)
    debitors.each do |debitor|
      debitor.set_as_suspended
    end
  end
end
