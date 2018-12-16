module Sinatra
  module YitoExtension
    module PromotionCodeManagementRESTApi

      def self.registered(app)
        
        #
        # Check the promotion code
        #
        app.post '/api/check-promotion-code/?' do 

          promotion_code = params[:code]
          date_from = date_to = nil

          if params[:from]
            begin
              date_from = DateTime.strptime(params[:from], '%Y-%m-%d')
            rescue
              logger.error("from date not valid #{params[:from]}")
            end
          end

          if params[:to]
            begin
              date_to = DateTime.strptime(params[:to], '%Y-%m-%d')
            rescue
              logger.error("to date not valid #{params[:to]}")
            end
          end

          #p "promotion code: #{promotion_code} -- from: #{date_from} -- to: #{date_to}"

          if ::Yito::Model::Rates::PromotionCode.valid_code?(promotion_code, date_from, date_to)
            content_type :json
            true.to_json
          else
            content_type :json
            false.to_json
          end

        end

        #                    
        # Query promotion codes
        #
        ["/api/promotion-codes","/api/promotion-codes/page/:page"].each do |path|
          
          app.post path do

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
                               Conditions::Comparison.new(:promotion_code, '$like', "%#{search_request['search']}%")])
                total = conditions.build_datamapper(::Yito::Model::Rates::PromotionCode).all.count
                data = conditions.build_datamapper(::Yito::Model::Rates::PromotionCode).all(:limit => limit, :offset => offset)
              else
                data  = ::Yito::Model::Rates::PromotionCode.all(:limit => limit, :offset => offset)
                total = ::Yito::Model::Rates::PromotionCode.count
              end
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