class ActiveUsersQuery
  def self.perform(params)
    new(params).perform
  end

  attr_reader :order

  def initialize(params)
    @order = params[:order]
  end

  def perform
    case order
    when 'payments'
      (User.allowed.paid.sort_by { |u| u.last_payment.end_date } + User.allowed.signed_in).uniq
    when 'last_seen'
      User.active.sort_by { |u| u.last_seen_in_hackerspace.to_i }.reverse
    when 'course'
      User.all.sort_by { |u| u.is_learner.to_s }.reverse
    else
      User.active.sort_by { |u| u.id }
    end
  end
end
