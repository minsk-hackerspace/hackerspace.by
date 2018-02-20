class Admin::EripTransactionsController < AdminController
  before_action :set_erip_transaction, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:create, :bepaid_notify]
  before_action :check_if_admin, only: [:edit, :update, :create, :destroy]


  # GET /erip_transactions
  # GET /erip_transactions.json
  def index
    @erip_transactions = EripTransaction.all.order(paid_at: :desc).paginate(page: params[:page], per_page: 30)
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
        format.html { redirect_to [:admin, @erip_transaction], notice: 'Erip transaction was successfully created.' }
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
        format.html { redirect_to [:admin, @erip_transaction], notice: 'Erip transaction was successfully updated.' }
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
      format.html { redirect_to admin_erip_transactions_url, notice: 'Erip transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bepaid_notify
    transaction = params[:transaction]
    if transaction.nil?
      respond_to do |format|
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end

    logger.debug transaction

    et = EripTransaction.new
    et.status = transaction[:status]
    et.message = transaction[:message]
    et.transaction_type = transaction[:type]
    et.transaction_id = transaction[:id]
    et.uid = transaction[:uid]
    et.order_id = transaction[:order_id]
    et.amount = BigDecimal.new(transaction[:amount]) / 100 # amount is in 1/100 BYN
    et.currency = transaction[:currency]
    et.tracking_id = transaction[:tracking_id]
    et.transaction_created_at = DateTime.parse(transaction[:created_at])
    et.expired_at = DateTime.parse(transaction[:expired_at])
    et.paid_at = DateTime.parse(transaction[:paid_at])
    et.test = transaction[:test]
    et.payment_method_type = transaction[:payment_method_type]
    et.billing_address = transaction[:billing_address]
    et.customer = transaction[:customer]
    et.payment = transaction[:payment]
    et.erip = transaction[:erip]

    if et.erip['service_no'].to_i == Setting['bePaid_serviceNo'].to_i
      u = User.find et.erip['account_number'].to_i
      et.user = u
    end

    @erip_transaction = et

    logger.debug "Parsed transaction: " + et.inspect

    respond_to do |format|
      if @erip_transaction.save
        format.json { render :show, status: :created, location: admin_erip_transaction_url(@erip_transaction) }
      else
        format.json { render json: @erip_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_erip_transaction
      @erip_transaction = EripTransaction.find(params[:id])
    end

    def check_if_admin
      flash[:alert] = "У вас нет прав на это действие"
      redirect_to admin_erip_transactions_path unless current_user.admin?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def erip_transaction_params
      params.require(:erip_transaction).permit(:status, :message, :type, :transaction_id, :uid, :order_id, :amount, :currency, :description, :tracking_id, :transaction_created_at, :expired_at, :paid_at, :test, :payment_method_type, :billing_address, :customer, :payment, :erip)
    end
end
