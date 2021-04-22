class DashboardController < ApplicationController
  include ApplicationHelper

  before_action :prepare_charts_data, only: [:index]
  after_action :user_introduction, only: [:index], if: -> { current_user.introduction.present? && !current_user.introduction.dashboard? }
  def index
    @recent_activity = Reporting::Dashboard.get_recent_activity(@currency, @current_company_id).group_by { |d| d[:activity_date] }
    @current_invoices = Invoice.current_invoices(@current_company_id).limit(10)
    @past_invoices = Invoice.past_invoices(@current_company_id).limit(10)


    @ytd_invoices = Invoice.by_company(current_company).in_year(Date.today.year).joins(payments: :currency).where('payments.payment_date <= ?', Date.today)

    @unit_size='medium-unit'


    respond_to do |format|
      format.html
    end
  end

  def chart_details
    current_company_id = get_company_id
    @currency = params[:currency].present? ? Currency.find_by_id(params[:currency]) : Currency.default_currency
    @chart_details = Reporting::Dashboard.get_chart_details(params.merge(current_company_id: current_company_id))
    @chart_total = params[:chart_for] == 'invoices' ? @chart_details.sum(:invoice_total) : @chart_details.sum(:payment_amount)
    render partial: "#{params[:chart_for]}_detail"
  end

  private
  def prepare_charts_data
    @current_company_invoices = Invoice.by_company(current_company).joins(:currency)
    @current_company_payments = Payment.by_company(current_company).joins(:currency)

    @current_company_id = get_company_id
    @current_company = Company.find @current_company_id
    @currenct_company_base_currency = @current_company.base_currency
    @currency = params[:currency].present? ? Currency.find_by_id(params[:currency]) : Currency.default_currency


    prepare_base_currency_charts_data
    prepare_multi_currency_charts_data

    @currencies_chart_data = @current_company_invoices.group('currencies.unit').count
  end

  def prepare_base_currency_charts_data
    @invoices_chart_data_base = @current_company_invoices.where('invoices.invoice_date > ?', 6.months.ago).order('invoice_date asc').group('MONTHNAME(invoices.invoice_date)').sum('invoices.base_currency_equivalent_total')
    @invoices_chart_data_base = @invoices_chart_data_base.map{|k, v| [[@currenct_company_base_currency.unit, k],v] }.to_h
  end

  def prepare_multi_currency_charts_data
    invoices_chart_data = @current_company_invoices.where('invoices.invoice_date > ?', 6.months.ago).order('invoice_date asc').group('currencies.unit').group('MONTHNAME(invoices.invoice_date)').sum('invoices.invoice_total')
    currencies = invoices_chart_data.keys.collect{|a| a.first}.uniq
    @invoices_chart_data = {}
    currencies.each do |currency|
      5.downto(0) do |n|
        month = Date::MONTHNAMES[(Date.today - n.months).month]
        invoices_chart_data[[currency, month]].nil? ? @invoices_chart_data.merge!({[currency, month] => 0.0}) : @invoices_chart_data.merge!({[currency, month] => invoices_chart_data[[currency, month]]})
      end
    end

    payments_chart_data = @current_company_payments.where('payments.created_at > ?', 6.months.ago).order('payments.created_at asc').group('currencies.unit').group('MONTHNAME(payments.created_at)').sum('payments.payment_amount')
    currencies = invoices_chart_data.keys.collect{|a| a.first}.uniq
    @payments_chart_data = {}
    currencies.each do |currency|
      5.downto(0) do |n|
        month = Date::MONTHNAMES[(Date.today - n.months).month]
        payments_chart_data[[currency, month]].nil? ? @payments_chart_data.merge!({[currency, month] => 0.0}) : @payments_chart_data.merge!({[currency, month] => payments_chart_data[[currency, month]]})
      end
    end
  end
end
