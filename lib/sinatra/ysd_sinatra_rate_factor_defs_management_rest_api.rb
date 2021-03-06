#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module FactorDefinitionManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate factors
        #
        ["/api/rate-factor-defs","/api/rate-factor-defs/page/:page"].each do |path|
          
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
                               Conditions::Comparison.new(:name, '$like', "%#{search_request['search']}%")])
                total = conditions.build_datamapper(::Yito::Model::Rates::FactorDefinition).all.count
                data = conditions.build_datamapper(::Yito::Model::Rates::FactorDefinition).all(:limit => limit, :offset => offset)
              else
                data  = ::Yito::Model::Rates::FactorDefinition.all(:limit => limit, :offset => offset)
                total = ::Yito::Model::Rates::FactorDefinition.count
              end
            else
              data  = ::Yito::Model::Rates::FactorDefinition.all(:limit => limit, :offset => offset)
              total = ::Yito::Model::Rates::FactorDefinition.count
            end
            
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get rate factor
        #
        app.get "/api/rate-factor-defs" do

          data = ::Yito::Model::Rates::FactorDefinition.all

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a rate-factor
        #
        app.get "/api/rate-factor-def/:id" do
        
          data = ::Yito::Model::Rates::FactorDefinition.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new rate-factor
        #
        app.post "/api/rate-factor-def" do
        
          data_request = body_as_json(::Yito::Model::Rates::FactorDefinition)
          data = ::Yito::Model::Rates::FactorDefinition.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a rate-factor
        #
        app.put "/api/rate-factor-def" do
          
          data_request = body_as_json(::Yito::Model::Rates::FactorDefinition)
                              
          if data = ::Yito::Model::Rates::FactorDefinition.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a rate factor 
        #
        app.delete "/api/rate-factor-def" do
        
          data_request = body_as_json(::Yito::Model::Rates::FactorDefinition)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::FactorDefinition.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end