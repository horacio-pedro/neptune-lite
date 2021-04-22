module RecurringProfilesHelper
  def new_recurring_message(is_currently_sent)
    message = is_currently_sent ? "Recurring profile has been created and sent to #{@recurring_profile.client.organization_name}" : "Recurring profile has been created successfully"
    notice = <<-HTML
       <p>#{message}.</p>
       <ul>
         <li><a href="/recurring_profiles/new">Create another recurring profile</a></li>
       </ul>
    HTML
    notice.html_safe
  end

  def recurring_profiles_archived ids
    notice = <<-HTML
     <p>#{ids.size} recurring profile(s) have been archived. You can find them under
     <a href="?status=archived&per=#{@per_page}" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='recurring_profiles/undo_actions?ids=#{ids.join(",")}&archived=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">Undo this action</a> to move archived recurring profiles back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def recurring_profiles_deleted ids
    notice = <<-HTML
     <p>#{ids.size} recurring profile(s) have been deleted. You can find them under
     <a href="?status=deleted&per=#{@per_page}" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='recurring_profiles/undo_actions?ids=#{ids.join(",")}&deleted=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">Undo this action</a> to move deleted recurring profiles back to active.</p>
    HTML
    notice = notice.html_safe
  end
end
