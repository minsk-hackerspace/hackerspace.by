module HackersHelper
  def row_class(hacker)
    return if hacker.inactive?

    if hacker.last_payment.present? && hacker.last_payment.end_date < Time.now.to_date
      return hacker.is_learner? ? 'info' : 'danger'
    end

    'warning'
  end
end
