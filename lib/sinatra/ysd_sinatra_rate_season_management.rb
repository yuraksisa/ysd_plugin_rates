module Sinatra
  module YitoExtension
    module SeasonManagement

      def self.registered(app)

        #
        # Season definitio page
        #
        app.get '/admin/rates/seasons/:season_def_id/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          if season_definition = ::Yito::Model::Rates::SeasonDefinition.get(params[:season_def_id])
            locals = {:rate_season_page_size => 20, :season_definition => season_definition}
            load_em_page :rate_season_management, nil, false, :locals => locals
          else
            status 404
          end

        end

      end

    end
  end
end