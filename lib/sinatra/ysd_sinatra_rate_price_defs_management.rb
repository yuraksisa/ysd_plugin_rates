module Sinatra
  module YitoExtension
    module PriceDefinitionManagement

      def self.registered(app)

        #
        # Price definition page
        #
        app.get '/admin/rates/price-defs/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          locals = {:rate_price_defs_page_size => 20}
          load_em_page :rate_price_defs_management, nil, false, :locals => locals

        end

      end

    end
  end
end