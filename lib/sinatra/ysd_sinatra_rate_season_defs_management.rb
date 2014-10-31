module Sinatra
  module YitoExtension
    module SeasonDefinitionManagement

      def self.registered(app)

        #
        # Season definitio page
        #
        app.get '/admin/rates/season-defs/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          locals = {:rate_season_defs_page_size => 20}
          load_em_page :rate_season_defs_management, nil, false, :locals => locals

        end

      end

    end
  end
end