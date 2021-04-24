module Services
  class ProjectBulkActionsService
    attr_reader :projects, :project_ids, :options, :action_to_perform

    def initialize(options)
      actions_list = %w(archive destroy recover_archived recover_deleted destroy_archived)
      @options = options
      @action_to_perform = actions_list.map { |action| action if @options[action] }.compact.first #@options[:commit]
      @project_ids = @options[:project_ids]
      @projects = ::Project.multiple(@project_ids)
      @current_user = @options[:current_user]
    end

    def perform
      method(@action_to_perform).call.merge({project_ids: @project_ids, action_to_perform: @action_to_perform})
    end

    def archive
      @projects.map(&:archive)
      {action: 'archived', projects: get_projects('unarchived')}
    end

    def destroy
      (@projects).map(&:destroy)
      {action: 'deleted', projects: get_projects('unarchived')}
    end

    def destroy_archived
      (@projects).map(&:destroy)
      {action: 'deleted from archived', projects: get_projects('archived')}
    end

    def recover_archived
      @projects.map(&:unarchive)
      {action: 'recovered from archived', projects: get_projects('archived')}
    end

    def recover_deleted
      @projects.only_deleted.map { |project| project.restore; project.unarchive;}
      projects = ::Project.only_deleted.page(@options[:page]).per(@options[:per])
      {action: 'recovered from deleted', projects: get_projects('only_deleted')}
    end

    private

    def get_projects(project_filter)
      ::Project.joins("LEFT OUTER JOIN clients ON clients.id = projects.client_id ").send(project_filter).page(@options[:page]).per(@options[:per])
    end
  end
end
