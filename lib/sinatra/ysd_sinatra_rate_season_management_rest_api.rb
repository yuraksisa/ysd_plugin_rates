#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module SeasonManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate seasons
        #
        ["/api/rate-seasons/:season_def_id","/api/rate-seasons/:season_def_id/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = settings.contents_page_size
            offset = (page-1) * settings.contents_page_size

            data  = ::Yito::Model::Rates::Season.all(:season_definition_id => params[:season_def_id], :limit => limit, :offset => offset, :order => [:from_month.asc, :from_day.asc])
            total = ::Yito::Model::Rates::Season.count
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get rate season
        #
        app.get "/api/rate-seasons/:season_def_id" do

          data = ::Yito::Model::Rates::Season.all(:season_definition_id => params[:season_def_id])

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a rate season
        #
        app.get "/api/rate-season/:id" do
        
          data = ::Yito::Model::Rates::Season.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new rate season
        #
        app.post "/api/rate-season" do
        
          data_request = body_as_json(::Yito::Model::Rates::Season)
          data = ::Yito::Model::Rates::Season.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a rate-season
        #
        app.put "/api/rate-season" do
          
          data_request = body_as_json(::Yito::Model::Rates::Season)
                              
          if data = ::Yito::Model::Rates::Season.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a rate season 
        #
        app.delete "/api/rate-season" do
        
          data_request = body_as_json(::Yito::Model::Rates::Season)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::Season.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end