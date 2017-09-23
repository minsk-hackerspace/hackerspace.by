# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  state      :float            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_balances_on_created_at  (created_at)
#  index_balances_on_updated_at  (updated_at)
#

class Balance < ApplicationRecord
  def self.graph(start_date, end_date)
    Rails.cache.fetch [start_date, end_date, :balance_graph] do
      balances = Balance.where(created_at: [start_date..end_date]).to_a
      graph = []
      (start_date..end_date).to_a.each do |date|
        state = balances.select {|b| b.created_at >= date.beginning_of_day and b.created_at <= date.end_of_day}.last.try(:state)
        graph << [date.strftime('%d-%b-%y'), state || graph.last.try(:last) || 0]
      end
      graph
    end
  end
end
