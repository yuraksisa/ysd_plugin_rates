module Sinatra
  module YitoExtension
    module DiscountManagementRESTApi

      def self.registered(app)

        #                    
        # Query discounts
        #
        ["/api/discounts","/api/discounts/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = 20
            offset = (page-1) * 20

            conditions = {}         
            
            if request.media_type == "application/json"
              request.body.rewind
              search_request = JSON.parse(URI.unescape(request.body.read))
              if search_request.has_key?('search') and !search_request['search'].empty?
                conditions = Conditions::Comparison.new(:id, '$eq', search_request['search'].to_i)
                total = conditions.build_datamapper(::Yito::Model::Rates::Discount).all.count
                data = conditions.build_datamapper(::Yito::Model::Rates::Discount).all(:limit => limit, :offset => offset)
              else
                data  = ::Yito::Model::Rates::Discount.all(:limit => limit, :offset => offset)
                total = ::Yito::Model::Rates::Discount.count
              end
            else
              data  = ::Yito::Model::Rates::Discount.all(:limit => limit, :offset => offset)
              total = ::Yito::Model::Rates::Discount.count
            end
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get discounts
        #
        app.get "/api/discounts" do

          data = ::Yito::Model::Rates::Discount.all

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a discount
        #
        app.get "/api/discount/:id" do
        
          data = ::Yito::Model::Rates::Discount.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new discount
        #
        app.post "/api/discount" do
        
          data_request = body_as_json(::Yito::Model::Rates::Discount)
          data = ::Yito::Model::Rates::Discount.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a discount
        #
        app.put "/api/discount" do
          
          data_request = body_as_json(::Yito::Model::Rates::Discount)
                              
          if data = ::Yito::Model::Rates::Discount.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a discount 
        #
        app.delete "/api/discount" do
        
          data_request = body_as_json(::Yito::Model::Rates::Discount)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::Discount.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end