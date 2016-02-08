#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module PromotionCodeManagementRESTApi

      def self.registered(app)

        #                    
        # Query promotion codes
        #
        ["/api/promotion-codes","/api/promotion-codes/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = 20
            offset = (page-1) * 20

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
                               Conditions::Comparison.new(:promotion_code, '$like', "%#{search_text}%")])   

              total = conditions.build_datamapper(::Yito::Model::Rates::PromotionCode).all.count 
              data = conditions.build_datamapper(::Yito::Model::Rates::PromotionCode).all(:limit => limit, :offset => offset) 
            else
              data  = ::Yito::Model::Rates::PromotionCode.all(:limit => limit, :offset => offset)
              total = ::Yito::Model::Rates::PromotionCode.count
                                          
            end
            
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get promotion codes
        #
        app.get "/api/promotion-codes" do

          data = ::Yito::Model::Rates::PromotionCode.all

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a promotion code
        #
        app.get "/api/promotion-code/:id" do
        
          data = ::Yito::Model::Rates::PromotionCode.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new promotion code
        #
        app.post "/api/promotion-code" do
        
          data_request = body_as_json(::Yito::Model::Rates::PromotionCode)
          data = ::Yito::Model::Rates::PromotionCode.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a promotion code
        #
        app.put "/api/promotion-code" do
          
          data_request = body_as_json(::Yito::Model::Rates::PromotionCode)
                              
          if data = ::Yito::Model::Rates::PromotionCode.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a promotion code 
        #
        app.delete "/api/promotion-code" do
        
          data_request = body_as_json(::Yito::Model::Rates::PromotionCode)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::PromotionCode.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end