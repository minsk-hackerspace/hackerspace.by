# frozen_string_literal: true

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
      graph = []
      (start_date..end_date).each do |date|
        state = Balance.where('created_at >= ? AND created_at <= ?',
                              date.beginning_of_day, date.end_of_day).last.try(:state)
        graph << [date.strftime('%d-%b-%y'), state || graph.last.try(:last) || 0]
      end
      graph
    end
  end
end
