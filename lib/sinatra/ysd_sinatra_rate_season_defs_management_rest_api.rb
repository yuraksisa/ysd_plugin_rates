#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module SeasonDefinitionManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate seasons
        #
        ["/api/rate-season-defs","/api/rate-season-defs/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = settings.contents_page_size
            offset = (page-1) * settings.contents_page_size

            conditions = {}         
            
            if request.media_type == "application/x-www-form-urlencoded" # Just the text
              search_text = if params[:search]
                              params[:search]
                            else
                              request.body.rewind
                              request.body.read
                            end
              conditions = Conditions::JoinComparison.new('$or', 
                              [Conditions::Comparison.new(:id, '$eq', search_text.to_i),
                               Conditions::Comparison.new(:name, '$like', "%#{search_text}%")])   

              total = conditions.build_datamapper(::Yito::Model::Rates::SeasonDefinition).all.count 
              data = conditions.build_datamapper(::Yito::Model::Rates::SeasonDefinition).all(:limit => limit, :offset => offset) 
            else
              data  = ::Yito::Model::Rates::SeasonDefinition.all(:limit => limit, :offset => offset)
              total = ::Yito::Model::Rates::SeasonDefinition.count
                                          
            end
            
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get calendars
        #
        app.get "/api/rate-season-defs" do

          data = ::Yito::Model::Rates::SeasonDefinition.all

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a rate-seaon
        #
        app.get "/api/rate-season-def/:id" do
        
          data = ::Yito::Model::Rates::SeasonDefinition.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new rate-seaon
        #
        app.post "/api/rate-season-def" do
        
          data_request = body_as_json(::Yito::Model::Rates::SeasonDefinition)
          data = ::Yito::Model::Rates::SeasonDefinition.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a rate-seaon
        #
        app.put "/api/rate-season-def" do
          
          data_request = body_as_json(::Yito::Model::Rates::SeasonDefinition)
                              
          if data = ::Yito::Model::Rates::SeasonDefinition.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a calendar
        #
        app.delete "/api/rate-season-def" do
        
          data_request = body_as_json(::Yito::Model::Rates::SeasonDefinition)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::SeasonDefinition.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end