require 'grape-swagger'

module V1
  class OSB < Grape::API

    version 'v1', using: :path, vendor: 'osb'
    format :json
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ errors: e.full_messages.map { |msg| msg }, message: nil}, 400)
    end

    helpers do
      def current_token
        Doorkeeper::AccessToken.authenticate request.headers["Access-Token"]
      end
      def current_user
        @current_user ||= ::User.find_by(authentication_token: request.headers["Access-Token"]) if request.headers["Access-Token"]
        if @current_user
          User.current = @current_user
        else
          error!('Unauthorized. Invalid or expired token.', 401)
        end
      end

      def per_page
        params[:per] || 25
      end

      def current_page
        params[:page] || 1
      end

      #set session of company_id
      def set_company_session
        unless params[:company_id].blank?
          session['current_company'] = params[:company_id]
          current_user.update_attributes(current_company: params[:company_id])
        end
      end
    end
    mount V1::OSB::ClientApi
    mount V1::OSB::AccountApi
    mount V1::OSB::CompanyApi
    mount V1::OSB::InvoiceApi
    mount V1::OSB::ItemApi
    mount V1::OSB::PaymentApi
    mount V1::OSB::TaxApi
    mount V1::OSB::DashboardApi
    mount V1::OSB::ReportApi
    mount V1::OSB::ExpenseApi
    mount V1::OSB::EstimateApi
    mount V1::OSB::LogApi
    mount V1::OSB::TaskApi
    mount V1::OSB::StaffApi
    mount V1::OSB::RecurringFrequencyApi
    mount V1::OSB::SettingsApi
    mount V1::OSB::UserApi
    mount V2::InvoiceApi
    add_swagger_documentation(
        base_path: "/api",
        hide_documentation_path: true
    )
  end
end
