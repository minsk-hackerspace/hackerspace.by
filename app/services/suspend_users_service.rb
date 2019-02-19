class SuspendUsersService
  attr_reader :debitors

  def initialize
    @debitors = User.with_debt
  end

  def set_users_as_suspended
    debitors.each do |debitor|
      debitor.set_as_suspended
    end
  end
end
