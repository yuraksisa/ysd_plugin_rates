module Sinatra
  module YitoExtension
    module PriceManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate prices
        #
        ["/api/rate-prices/:price_def_id","/api/rate-prices/:price_def_id/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = settings.contents_page_size
            offset = (page-1) * settings.contents_page_size

            data  = ::Yito::Model::Rates::Price.all_season_ordered.all(:price_definition_id => params[:price_def_id], :limit => limit, :offset => offset)
            total = ::Yito::Model::Rates::Price.count
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get rate price
        #
        app.get "/api/rate-prices/:price_def_id" do

          data = ::Yito::Model::Rates::Price.all_season_ordered.all(:price_definition_id => params[:price_def_id])

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a rate price
        #
        app.get "/api/rate-price/:id" do
        
          data = ::Yito::Model::Rates::Price.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new rate price
        #
        app.post "/api/rate-price" do
        
          data_request = body_as_json(::Yito::Model::Rates::Price)
          data = ::Yito::Model::Rates::Price.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a rate-price
        #
        app.put "/api/rate-price" do
          
          data_request = body_as_json(::Yito::Model::Rates::Price)
                              
          if data = ::Yito::Model::Rates::Price.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a rate price 
        #
        app.delete "/api/rate-price" do
        
          data_request = body_as_json(::Yito::Model::Rates::Price)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::Price.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end