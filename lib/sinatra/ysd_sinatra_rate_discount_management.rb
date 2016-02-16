module Sinatra
  module YitoExtension
    module DiscountManagement

      def self.registered(app)

        #
        # Factor definition page
        #
        app.get '/admin/rates/discounts/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          locals = {:discount_page_size => 20}
          load_em_page :discount_management, nil, false, :locals => locals

        end

      end

    end
  end
end