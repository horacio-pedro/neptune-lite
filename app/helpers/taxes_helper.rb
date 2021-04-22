module TaxesHelper
  def new_tax id
    notice = <<-HTML
       <p>#{t('views.taxes.created_msg')}</p>
    HTML
    notice.html_safe
  end

  def taxes_archived ids
    notice = <<-HTML
     <p>#{ids.size} #{t('views.taxes.bulk_archived')}
     <a href="taxes/filter_taxes?status=archived&per=#{@per_page}" data-remote="true">#{t('views.common.archive')}</a> #{t('views.items.section_on_page')}</p>
     <p><a href='taxes/undo_actions?ids=#{ids.join(",")}&archived=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">#{t('views.items.undo_action')}</a> #{t('views.taxes.to_unarchived_tax')}</p>
    HTML
    notice.html_safe
  end

  def taxes_deleted ids
    notice = <<-HTML
     <p>#{ids.size} #{t('views.taxes.bulk_deleted_msg')}
     <a href="taxes/filter_taxes?status=deleted&per=#{@per_page}" data-remote="true">#{t('views.common.deleted')}</a> #{t('views.items.section_on_page')}</p>
     <p><a href='taxes/undo_actions?ids=#{ids.join(",")}&deleted=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">#{t('views.items.undo_action')}</a> #{t('views.taxes.to_move_deleted_tax')}</p>
    HTML
    notice.html_safe
  end

  def qb_tax_rate?(txn_tax_detail)
    txn_tax_detail && txn_tax_detail['TaxLine'].present? && txn_tax_detail['TaxLine'][0]['TaxLineDetail']['TaxRateRef'].present?
  end
end
