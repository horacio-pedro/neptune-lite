module Services
  #invoice related business logic will go here
  class ProjectService
    include DateFormats


    # invoice bulk actions
    def self.perform_bulk_action(params)
      Services::ProjectBulkActionsService.new(params).perform
    end

  end
end