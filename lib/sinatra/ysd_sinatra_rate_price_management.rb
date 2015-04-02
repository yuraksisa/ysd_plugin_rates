require ysd_md_rates unless defined?Yito::Model::Rates::FactorDefinition
module Sinatra
  module YitoExtension
    module PriceManagement

      def self.registered(app)

        app.get '/admin/rates/prices/:price_def_id/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          if price_definition = ::Yito::Model::Rates::PriceDefinition.get(params[:price_def_id])
            prices = {}
            if price_definition.type == :no_season
              price_definition.prices.each do |price|
                  prices[price.units] = {} 
                  prices[price.units][:id] = price.id
                  prices[price.units][:price] = price.price
              end
              locals = {:price_definition => price_definition, :prices => prices}
              load_page :rate_price_assistant_no_season, :locals => locals
            else
              price_definition.season_definition.seasons.each do |season|
                prices.store(season.id, {})
              end
              price_definition.prices.each do |price|
                if price.season and prices.has_key?(price.season.id)
                  prices[price.season.id][price.units] = {} if prices[price.season.id][price.units].nil?
                  prices[price.season.id][price.units][:id] = price.id
                  prices[price.season.id][price.units][:price] = price.price
                end
              end
              locals = {:price_definition => price_definition, :prices => prices}
              load_page :rate_price_assistant, :locals => locals
            end
          else
            status 404
          end
        

        end

        app.get '/admin/rates/adjust-prices/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          load_page(:adjust_prices)

        end

      end

    end
  end
end