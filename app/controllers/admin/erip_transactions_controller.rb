class Admin::EripTransactionsController < AdminController
  before_action :set_erip_transaction, only: [:show, :edit, :update, :destroy]
#  before_action :authenticate_user!, except: [:create, :bepaid_notify]
#  before_action :check_if_admin, only: [:edit, :update, :create, :destroy, :index]
  load_and_authorize_resource

  skip_before_action :verify_authenticity_token, only: :bepaid_notify

  http_basic_authenticate_with name: Setting['bePaid_ID'],
                               password: Setting['bePaid_secret'],
                               only: :bepaid_notify

  # GET /erip_transactions
  # GET /erip_transactions.json
  def index
    @erip_transactions = EripTransaction.order(paid_at: :desc).page(params[:page])
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
    if transaction.nil? ||
        (transaction[:id].present? && EripTransaction.where(transaction_id: transaction[:id]).exists?)

      respond_to do |format|
        format.json { render json: {}, status: :unprocessable_entity }
      end
      return
    end

    logger.debug transaction

    et = EripTransaction.new
    et.status = transaction[:status]
    et.message = transaction[:message]
    et.transaction_type = transaction[:type]
    et.transaction_id = transaction[:id]
    et.uid = transaction[:uid]
    et.order_id = transaction[:order_id]
    et.amount = BigDecimal(transaction[:amount]) / 100 # amount is in 1/100 BYN
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
      et.user = User.find_by(id: et.erip['account_number'].to_i)
    end

    if et.status == 'successful'
      p = Payment.new
      p.erip_transaction = et
      et.hs_payment = p
      p.amount = et.amount
      p.paid_at = et.paid_at
      p.user = et.user
      p.payment_type = et.erip['service_no'].to_i == Setting['bePaid_serviceNo'].to_i ? 'membership' : 'donation'
      p.payment_form = 'erip'
      if p.payment_type == 'membership' then
        last_payment = nil
        last_payment = p.user.last_payment unless p.user.nil?
        unless last_payment.nil? or last_payment.end_date < et.paid_at.to_date - 14.days
          p.start_date = last_payment.end_date + 1.day
        else
          p.start_date = et.paid_at.to_date
        end

        m_amount = p.user.nil? ? 70.0 :  p.user.monthly_payment_amount

        m = p.amount.div m_amount
        d = ((p.amount - m * m_amount) / m_amount * 30).floor
        p.end_date = p.start_date + m.months + d.days - 1.day
      else
        p.project = Project.find_by(id: et.erip['account_number'].to_i)
      end
    end
    @erip_transaction = et

    logger.debug "Parsed transaction: " + et.inspect

    respond_to do |format|
      if @erip_transaction.save
        format.json { render :show, status: :created, location: admin_erip_transaction_url(@erip_transaction) }
        unless @erip_transaction.user.nil? or @erip_transaction.status != "successful"
          NotificationsMailer.with(transaction: @erip_transaction).notify_about_payment.deliver_later 
        end
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
      unless current_user.admin?
        flash[:alert] = "У вас нет прав на это действие"
        redirect_to admin_erip_transactions_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def erip_transaction_params
      params.require(:erip_transaction).permit(:status, :message, :type, :transaction_id, :uid, :order_id, :amount, :currency, :description, :tracking_id, :transaction_created_at, :expired_at, :paid_at, :test, :payment_method_type, :billing_address, :customer, :payment, :erip)
    end
end
