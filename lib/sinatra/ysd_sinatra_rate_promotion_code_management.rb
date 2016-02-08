module Sinatra
  module YitoExtension
    module PromotionCodeManagement

      def self.registered(app)

        #
        # Factor definition page
        #
        app.get '/admin/rates/promotion-codes/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          locals = {:promotion_code_page_size => 20}
          load_em_page :promotion_code_management, nil, false, :locals => locals

        end

      end

    end
  end
end