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
            limit = 20
            offset = (page-1) * 20

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
            begin
              data.save
            rescue DataMapper::SaveFailureError => error
             p "Error saving price #{error} #{data.inspect} #{data.errors.inspect}"
             raise error 
            end            
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

        #
        # Massive price update
        #
        app.post '/api/rate-price-masive-update', :allowed_usergroups => ['rates_manager','staff'] do

          request.body.rewind
          data = JSON.parse(URI.unescape(request.body.read)) 
          data.symbolize_keys! 

          seasons = data[:seasons]
          price_definitions = data[:price_def]
          amount_operation = data[:amount_operation]
          amount = BigDecimal.new(data[:amount])

          if seasons.is_a?Array and seasons.size > 0 and
             price_definitions.is_a?Array and price_definitions.size > 0 and
             ['*','+','-','/',' '].index(amount_operation) >= 0 and
             amount.is_a?BigDecimal
       
            ::Yito::Model::Rates::Price.all(
               :season => {:id => seasons}, 
               :price_definition => {:id => price_definitions})
               .update(:adjust_operation => amount_operation,
                       :adjust_amount => amount)

            content_type :json
            true.to_json
       
          else
            status 500
          end

        end 

      end
    end
  end
end