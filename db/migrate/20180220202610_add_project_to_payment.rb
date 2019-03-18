class AddProjectToPayment < ActiveRecord::Migration[5.1]
  def up
    add_belongs_to :payments, :project

    EripTransaction.all.each do |et|
      next if et.hs_payment.nil?
      next unless et.hs_payment.payment_type == 'donation'
      
      begin
        proj = Project.find(et.erip['account_number'].to_i)
        et.hs_payment.project = proj
      rescue
      end

      et.hs_payment.save
    end
  end

  def down
    remove_belongs_to :payments, :project
  end
end
