require ysd_md_rates unless defined?Yito::Model::Rates::FactorDefinition
module Sinatra
  module YitoExtension
    module PriceManagement

      def self.registered(app)

        #
        # Factor definition page
        #
        app.get '/admin/rates/prices/:price_def_id/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          if price_definition = ::Yito::Model::Rates::PriceDefinition.get(params[:price_def_id])
            locals = {:rate_price_page_size => 20, :price_definition => price_definition}
            load_em_page :rate_price_management, nil, false, :locals => locals
          else
            status 404
          end

        end

      end

    end
  end
end