require ysd_md_rates unless defined?Yito::Model::Rates::FactorDefinition
module Sinatra
  module YitoExtension
    module PriceManagement

      def self.registered(app)

        #
        # Load the section of price detail
        #
        app.get '/admin/rates/prices/:price_def_id/detail', :allowed_usergroups => ['rates_manager','staff'] do

          if @price_definition = ::Yito::Model::Rates::PriceDefinition.get(params[:price_def_id])
            @prices = build_prices(@price_definition)
            if @price_definition.type == :no_season
              partial :rate_assistant_rates_detail_no_season
            else
              @season_definition = @price_definition.season_definition
              partial :rate_assistant_rates_detail
            end
          else
            status 404
          end

        end

        #
        # Rates editor
        #
        app.get '/admin/rates/prices/:price_def_id', :allowed_usergroups => ['rates_manager','staff'] do

          if @price_definition = ::Yito::Model::Rates::PriceDefinition.get(params[:price_def_id])
            @prices = build_prices(@price_definition)
            if @price_definition.type == :no_season
              load_page :rate_price_assistant_no_season
            else
              @season_definition = @price_definition.season_definition
              load_page :rate_price_assistant
            end
          else
            status 404
          end

        end

        #
        # Massive adjust prices
        #
        app.get '/admin/rates/adjust-prices/?*', :allowed_usergroups => ['rates_manager','staff'] do 

          load_page(:adjust_prices)

        end

      end

    end
  end
end