class SuspendUsersService
  attr_reader :debitors

  def initialize
  end

  def set_users_as_suspended
    @debitors = User.with_debt
    debitors.each do |debitor|
      debitor.set_as_suspended
    end
  end
end
