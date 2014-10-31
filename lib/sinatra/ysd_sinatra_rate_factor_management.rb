require ysd_md_rates unless defined?Yito::Model::Rates::FactorDefinition
module Sinatra
  module YitoExtension
    module FactorManagement

      def self.registered(app)

        #
        # Factor definition page
        #
        app.get '/admin/rates/factors/:factor_def_id/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          if factor_definition = ::Yito::Model::Rates::FactorDefinition.get(params[:factor_def_id])
            locals = {:rate_factor_page_size => 20, :factor_definition => factor_definition}
            load_em_page :rate_factor_management, nil, false, :locals => locals
          else
            status 404
          end

        end

      end

    end
  end
end