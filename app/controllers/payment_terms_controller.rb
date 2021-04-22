class PaymentTermsController < ApplicationController
  # GET /payment_terms
  # GET /payment_terms.json
  def index
    @payment_terms = PaymentTerm.unscoped

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_terms }
    end
  end

  # GET /payment_terms/1
  # GET /payment_terms/1.json
  def show
    @payment_term = PaymentTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_term }
    end
  end

  # GET /payment_terms/new
  # GET /payment_terms/new.json
  def new
    @payment_term = PaymentTerm.new

    respond_to do |format|
      format.js
    end
  end

  # GET /payment_terms/1/edit
  def edit
    @payment_term = PaymentTerm.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /payment_terms
  # POST /payment_terms.json
  def create
    @payment_term = PaymentTerm.new(payment_term_params)

    respond_to do |format|
      if @payment_term.save
        format.js {
          flash[:notice]= 'Payment Term has been created successfully'
          render :js => "window.location.href='#{settings_path}'"
        }
        format.json { render :json => @payment_term, :status => :created, :location => @payment_term }
      else
        format.js
      end
    end
  end

  # PUT /payment_terms/1
  # PUT /payment_terms/1.json
  def update
    @payment_term = PaymentTerm.find(params[:id])

    respond_to do |format|
      if @payment_term.update_attributes(payment_term_params)
        format.js
        format.html { redirect_to @payment_term, notice: 'Payment term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_terms/1
  # DELETE /payment_terms/1.json
  def destroy
    @payment_term = PaymentTerm.find(params[:id])
    @payment_term.destroy

    respond_to do |format|
      format.html { redirect_to payment_terms_url }
      format.json { head :no_content }
    end
  end

  def destroy_bulk
    @payment_terms = PaymentTerm.where(id: params[:term_ids]).destroy_all
    render json: {notice: t('views.payment_terms.deleted_msg')}, status: :ok
  end

  private

  def payment_term_params
    params.require(:payment_term).permit(:description, :number_of_days)
  end

end
