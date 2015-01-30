module Sinatra
  module YitoExtension
    module FactorManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate factors
        #
        ["/api/rate-factors/:factor_def_id","/api/rate-factors/:factor_def_id/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = 20
            offset = (page-1) * 20

            data  = ::Yito::Model::Rates::Factor.all(:factor_definition_id => params[:factor_def_id], :limit => limit, :offset => offset, :order => [:from.asc])
            total = ::Yito::Model::Rates::Factor.count
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get rate factor
        #
        app.get "/api/rate-factors/:factor_def_id" do

          data = ::Yito::Model::Rates::Factor.all(:factor_definition_id => params[:factor_def_id])

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a rate factor
        #
        app.get "/api/rate-factor/:id" do
        
          data = ::Yito::Model::Rates::Factor.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new rate factor
        #
        app.post "/api/rate-factor" do
        
          data_request = body_as_json(::Yito::Model::Rates::Factor)
          data = ::Yito::Model::Rates::Factor.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a rate-factor
        #
        app.put "/api/rate-factor" do
          
          data_request = body_as_json(::Yito::Model::Rates::Factor)
                              
          if data = ::Yito::Model::Rates::Factor.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a rate factor 
        #
        app.delete "/api/rate-factor" do
        
          data_request = body_as_json(::Yito::Model::Rates::Factor)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::Factor.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end