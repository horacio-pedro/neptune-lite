module DashboardHelper
  def invoices_by_period period
    Reporting::Dashboard.get_invoices_by_period period
  end

  def number_to_currency_dashboard(number, options={})
    return nil unless number
    symbol       = options[:unit] || 'USD'
    precision    = options[:precision] || 2
    old_currency = number_to_currency(number, {precision: precision})
    old_currency.chr=='-' ? old_currency.slice!(1) : old_currency.slice!(0)
    ("#{old_currency} <#{options[:dom]}>#{symbol} </#{options[:dom]}>").html_safe
  end

  def aged_progress_width(amount, total)
    return 0 if total.to_i.eql?(0) or (amount == 0  or amount == nil)
    ((amount * 100)/total).round
  end
end
