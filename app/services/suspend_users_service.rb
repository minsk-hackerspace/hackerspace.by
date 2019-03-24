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

  def set_users_as_unsuspended
    User.not_banned.suspended.each do |user|
      if user.last_payment && (user.last_payment.end_date > Time.now )
        user.update_column(:account_suspended, false)
      end
    end
  end
end
