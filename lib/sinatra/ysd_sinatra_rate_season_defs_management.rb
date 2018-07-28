module Sinatra
  module YitoExtension
    module SeasonDefinitionManagement

      def self.registered(app)

        #
        # Season definition management
        #
        app.get '/admin/rates/season-defs/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          locals = {:rate_season_defs_page_size => 20}
          load_em_page :rate_season_defs_management, nil, false, :locals => locals

        end

        #
        # Season definition edition
        #
        app.get '/admin/rates/season-definition/:id', :allowed_usergroups => ['rates_manager', 'staff'] do

          if @season_definition = ::Yito::Model::Rates::SeasonDefinition.get(params[:id])
            load_page :season_definition_edition
          else
            status 404
          end

        end

      end

    end
  end
end