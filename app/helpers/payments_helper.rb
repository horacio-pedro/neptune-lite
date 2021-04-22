#
# Open Source Billing - A super simple software to create & send invoices to your customers and
# collect payments.
# Copyright (C) 2013 Mark Mian <mark.mian@opensourcebilling.org>
#
# This file is part of Open Source Billing.
module PaymentsHelper
  def payments_archived ids
    notice = <<-HTML
     <p>#{ids.size} payment(s) have been archived. You can find them under
     <a href="payments/filter_payments?status=archived" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='payments/undo_actions?ids=#{ids.join(",")}&archived=true&per=#{params[:per]}'  data-remote="true">Undo this action</a> to move archived payments back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def payments_deleted ids
    notice = <<-HTML
     <p>#{ids.size} payment(s) have been deleted. You can find them under
     <a href="payments/filter_payments?status=deleted" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='payments/undo_actions?ids=#{ids.join(",")}&deleted=true&per=#{params[:per]}'  data-remote="true">Undo this action</a> to move deleted payments back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def qb_currency?(currency)
    currency.present? && currency['value'].present?
  end

  def capitalize_amount amount
    a=amount.split(' ')
    a.map do |word|
      if word == "and"
        word.downcase
      else
        word.capitalize
      end
    end
  end

end