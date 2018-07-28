module Sinatra
  module RateHelpers

    #
    # Build prices from @price_definition variable
    #
    def build_prices(price_definition)

      prices = {}

      if price_definition.type == :no_season
        price_definition.prices.each do |price|
          prices[price.units] = {}
          prices[price.units][:id] = price.id
          prices[price.units][:price] = price.price
          prices[price.units][:adjust_operation] = price.adjust_operation
          prices[price.units][:adjust_amount] = price.adjust_amount
        end
      else
        price_definition.season_definition.seasons.each do |season|
          prices.store(season.id, {})
        end
        price_definition.prices.each do |price|
          if price.season and prices.has_key?(price.season.id)
            prices[price.season.id][price.units] = {} if prices[price.season.id][price.units].nil?
            prices[price.season.id][price.units][:id] = price.id
            prices[price.season.id][price.units][:price] = price.price
            prices[price.season.id][price.units][:adjust_operation] = price.adjust_operation
            prices[price.season.id][price.units][:adjust_amount] = price.adjust_amount
          end
        end
      end

      return prices

    end

  end
end