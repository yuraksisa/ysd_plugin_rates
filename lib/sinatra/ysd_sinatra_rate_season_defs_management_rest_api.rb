#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module SeasonDefinitionManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate season definitions
        #
        ["/api/rate-season-defs","/api/rate-season-defs/page/:page"].each do |path|
          
          app.post path, allowed_usergroups: ['rates_manager','staff']  do

            page = params[:page].to_i || 1
            limit = 20
            offset = (page-1) * 20

            conditions = {}         
            
            if request.media_type == "application/json"
              request.body.rewind
              search_request = JSON.parse(URI.unescape(request.body.read))
              if search_request.has_key?('search') and !search_request['search'].empty?
                conditions = Conditions::JoinComparison.new('$or', 
                              [Conditions::Comparison.new(:id, '$eq', search_request['search'].to_i),
                               Conditions::Comparison.new(:name, '$like', "%#{search_request['search']}%")])
                total = conditions.build_datamapper(::Yito::Model::Rates::SeasonDefinition).all.count 
                data = conditions.build_datamapper(::Yito::Model::Rates::SeasonDefinition).all(:limit => limit, :offset => offset)
              else
                data  = ::Yito::Model::Rates::SeasonDefinition.all(:limit => limit, :offset => offset)
                total = ::Yito::Model::Rates::SeasonDefinition.count
              end
            else
              data  = ::Yito::Model::Rates::SeasonDefinition.all(:limit => limit, :offset => offset)
              total = ::Yito::Model::Rates::SeasonDefinition.count
            end
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get rate season definitions
        #
        app.get "/api/rate-season-defs", allowed_usergroups: ['rates_manager','staff']  do

          data = ::Yito::Model::Rates::SeasonDefinition.all

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a rate season definition
        #
        app.get "/api/rate-season-def/:id", allowed_usergroups: ['rates_manager','staff']  do
        
          data = ::Yito::Model::Rates::SeasonDefinition.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new rate season definition
        #
        app.post "/api/rate-season-def", allowed_usergroups: ['rates_manager','staff']  do
        
          data_request = body_as_json(::Yito::Model::Rates::SeasonDefinition)
          data = ::Yito::Model::Rates::SeasonDefinition.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a rate season definition
        #
        app.put "/api/rate-season-def", allowed_usergroups: ['rates_manager','staff']  do
          
          data_request = body_as_json(::Yito::Model::Rates::SeasonDefinition)
                              
          if data = ::Yito::Model::Rates::SeasonDefinition.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a rate season definition
        #
        app.delete "/api/rate-season-def", allowed_usergroups: ['rates_manager','staff']  do
        
          data_request = body_as_json(::Yito::Model::Rates::SeasonDefinition)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::SeasonDefinition.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

        # ---------------------------------------------------------------------------------------

        #
        # Append a season to the season definition
        #
        app.post '/api/rate-season-def/:id/season', allowed_usergroups: ['rates_manager','staff'] do

          if season_definition = ::Yito::Model::Rates::SeasonDefinition.get(params[:id])

            request_data = body_as_json(::Yito::Model::Rates::Season)

            season = ::Yito::Model::Rates::Season.new(request_data)
            season.season_definition = season_definition
            season.save

            season_definition.reload

            # check season to see
            content_type :json
            {seasons: season_definition.seasons_by_date.to_a,
             errors: season_definition.seasons_errors,
             valid_seasons: season_definition.seasons_valid?}.to_json

          else
            status 404
          end

        end

        #
        # Updates a season
        #
        app.put '/api/rate-season/:id', allowed_usergroups: ['rates_manager','staff'] do

          if season = ::Yito::Model::Rates::Season.get(params[:id])

            request_data = body_as_json(::Yito::Model::Rates::Season)
            season.attributes = request_data
            season.save

            season_definition = season.season_definition
            season_definition.reload

            # check season to see
            content_type :json
            {seasons: season_definition.seasons_by_date.to_a,
             errors: season_definition.seasons_errors,
             valid_seasons: season_definition.seasons_valid?}.to_json

          else
            status 404
          end

        end

        #
        # Deletes a season
        #
        app.delete '/api/rate-season/:id', allowed_usergroups: ['rates_manager','staff'] do

          if season = ::Yito::Model::Rates::Season.get(params[:id])

            season_definition = season.season_definition

            season.destroy

            season_definition.reload

            # check season to see
            content_type :json
            {seasons: season_definition.seasons_by_date.to_a,
             errors: season_definition.seasons_errors,
             valid_seasons: season_definition.seasons_valid?}.to_json

          else
            status 404
          end

        end

      end
    end
  end
end