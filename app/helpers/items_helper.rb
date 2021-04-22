module ItemsHelper
  def new_item id
    notice = <<-HTML
       <p>#{t('views.items.created_msg')}</p>
    HTML
    notice = notice.html_safe
  end

  def items_archived ids
    notice = <<-HTML
     <p>#{ids.size} #{t('views.items.bulk_archived')}
     <a href="?status=archived&per=#{@per_page}" data-remote="true">#{t('views.common.archived')}</a> #{t('views.items.section_on_page')}</p>
     <p><a href='items/undo_actions?ids=#{ids.join(",")}&archived=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">#{t('views.items.undo_action')}</a> #{t('views.items.to_move_action')}</p>
    HTML
    notice = notice.html_safe
  end

  def items_deleted ids
    notice = <<-HTML
     <p>#{ids.size} #{t('views.items.items_deleted_msg')}
     <a href="?status=deleted&per=#{@per_page}" data-remote="true">#{t('views.common.deleted')}</a> #{t('views.items.section_on_page')}</p>
     <p><a href='items/undo_actions?ids=#{ids.join(",")}&deleted=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">#{t('views.items.undo_action')}</a> #{t('views.items.deleted_back_to_active')}</p>
    HTML
    notice = notice.html_safe
  end

  def qb_item_name?(sales_item_line_detail)
    sales_item_line_detail.present? && sales_item_line_detail['ItemRef'].present? && sales_item_line_detail['ItemRef']['name'].present?
  end

  def total_items_cost(items)
    sum = 0

    items.each do |item|
      quantity = item.quantity
      per_unit_cost = item.unit_cost
      total_item_cost = quantity * per_unit_cost
      sum = sum + total_item_cost
    end

    sum
  end

  def qb_item_name?(sales_item_line_detail)
    sales_item_line_detail.present? && sales_item_line_detail['ItemRef'].present? && sales_item_line_detail['ItemRef']['name'].present?
  end
end
