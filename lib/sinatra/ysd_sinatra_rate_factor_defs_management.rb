module Sinatra
  module YitoExtension
    module FactorDefinitionManagement

      def self.registered(app)

        #
        # Factor definition page
        #
        app.get '/admin/rates/factor-defs/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          locals = {:rate_factor_defs_page_size => 20}
          load_em_page :rate_factor_defs_management, nil, false, :locals => locals

        end

      end

    end
  end
end