class Admin::BankTransactionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_bank_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @filter = params[:filter]

    @bank_transactions = BankTransaction.all
    case @filter
      when BankTransaction::EXPENSES
        @bank_transactions = @bank_transactions.expenses
      when BankTransaction::INPAYMENTS
        @bank_transactions = @bank_transactions.inpayments
      end

    @bank_transactions = @bank_transactions.order(created_by: :desc, created_at: :desc).page(params[:page])
  end

  def mass_update
    bts = params.require(:bank_transactions)

    respond_to do |format|
      logger.debug bts.inspect
      if not bts.nil? and BankTransaction.update(bts.keys, bts.values)
        format.html { redirect_to request.referrer, notice: "Bank transactions have been successfully updated" }
      else
        format.html { redirect_to request.referrer, alert: "Bank transactions update failed" }
      end
    end
  end

  private
  def set_bank_transaction
    @bank_transaction = BankTransaction.find(params[:id])
  end

  def bank_transaction_params
    params.require(:bank_transaction).permit(:irregular, :note)
  end
end
