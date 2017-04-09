class Admin::EripTransactionsController < AdminController
  before_action :set_erip_transaction, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:create]


  # GET /erip_transactions
  # GET /erip_transactions.json
  def index
    @erip_transactions = EripTransaction.all
  end

  # GET /erip_transactions/1
  # GET /erip_transactions/1.json
  def show
  end

  # GET /erip_transactions/new
  def new
    @erip_transaction = EripTransaction.new
  end

  # GET /erip_transactions/1/edit
  def edit
  end

  # POST /erip_transactions
  # POST /erip_transactions.json
  def create
    @erip_transaction = EripTransaction.new(erip_transaction_params)

    respond_to do |format|
      if @erip_transaction.save
        format.html { redirect_to @erip_transaction, notice: 'Erip transaction was successfully created.' }
        format.json { render :show, status: :created, location: @erip_transaction }
      else
        format.html { render :new }
        format.json { render json: @erip_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /erip_transactions/1
  # PATCH/PUT /erip_transactions/1.json
  def update
    respond_to do |format|
      if @erip_transaction.update(erip_transaction_params)
        format.html { redirect_to @erip_transaction, notice: 'Erip transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @erip_transaction }
      else
        format.html { render :edit }
        format.json { render json: @erip_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /erip_transactions/1
  # DELETE /erip_transactions/1.json
  def destroy
    @erip_transaction.destroy
    respond_to do |format|
      format.html { redirect_to erip_transactions_url, notice: 'Erip transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_erip_transaction
      @erip_transaction = EripTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def erip_transaction_params
      params.require(:erip_transaction).permit(:status, :message, :type, :transaction_id, :uid, :order_id, :amount, :currency, :description, :tracking_id, :transaction_created_at, :expired_at, :paid_at, :test, :payment_method_type, :billing_address, :customer, :payment, :erip)
    end
end
