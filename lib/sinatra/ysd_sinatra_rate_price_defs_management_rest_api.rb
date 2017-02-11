#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module PriceDefinitionManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate price definition
        #
        ["/api/rate-price-defs","/api/rate-price-defs/page/:page"].each do |path|
          
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
                total = conditions.build_datamapper(::Yito::Model::Rates::PriceDefinition).all.count
                data = conditions.build_datamapper(::Yito::Model::Rates::PriceDefinition).all(:limit => limit, :offset => offset, :order => [:name.asc])
              else
                data  = ::Yito::Model::Rates::PriceDefinition.all(:limit => limit, :offset => offset, :order => [:name.asc])
                total = ::Yito::Model::Rates::PriceDefinition.count
              end
            else
              data  = ::Yito::Model::Rates::PriceDefinition.all(:limit => limit, :offset => offset, :order => [:name.asc])
              total = ::Yito::Model::Rates::PriceDefinition.count
            end
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get price definitions
        #
        app.get "/api/rate-price-defs" do

          data = ::Yito::Model::Rates::PriceDefinition.all(:name.not => nil ,:order => :name.asc)

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a price definition
        #
        app.get "/api/rate-price-def/:id" do
        
          data = ::Yito::Model::Rates::PriceDefinition.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new price definition
        #
        app.post "/api/rate-price-def" do
        
          data_request = body_as_json(::Yito::Model::Rates::PriceDefinition)
          data = ::Yito::Model::Rates::PriceDefinition.create(data_request)
         
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a price definition
        #
        app.put "/api/rate-price-def" do
          
          data_request = body_as_json(::Yito::Model::Rates::PriceDefinition)
                              
          if data = ::Yito::Model::Rates::PriceDefinition.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a  price definition
        #
        app.delete "/api/rate-price-def" do
        
          data_request = body_as_json(::Yito::Model::Rates::PriceDefinition)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Rates::PriceDefinition.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end