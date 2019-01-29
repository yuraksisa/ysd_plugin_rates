require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# Huasi CMS Extension
#
module Huasi
  class RatesExtension < Plugins::ViewListener

    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})

      SystemConfiguration::Variable.first_or_create(
          {name: 'rates.apply_discount_by_days'},
          {value: 'false',
           description: 'Apply discount by days in price calculation',
           module: :rates}
      )

      # Default season definition
      unless season_definition = Yito::Model::Rates::SeasonDefinition.first(name: 'general')
        season_definition = Yito::Model::Rates::SeasonDefinition.create(name: 'general', description: 'Temporadas generales')
        season = Yito::Model::Rates::Season.create(season_definition: season_definition, name: '1',
          from_day: 1, from_month: 1, to_day: 31, to_month: 12)
      end

      # Factor definition General
      unless factor_definition = Yito::Model::Rates::FactorDefinition.first(name: 'general')
        factor_definition = Yito::Model::Rates::FactorDefinition.create(name: 'general', description: 'Factores generales')
        factor_1 = Yito::Model::Rates::Factor.create(factor_definition: factor_definition, from: 1, to: 1, factor: 2)
        factor_2 = Yito::Model::Rates::Factor.create(factor_definition: factor_definition, from: 2, to: 2, factor: 1.5)
        factor_3 = Yito::Model::Rates::Factor.create(factor_definition: factor_definition, from: 3, to: 3, factor: 1.1)
      end

      # Discount by day general
      unless discount_by_day_definition = Yito::Model::Rates::DiscountByDayDefinition.first(name: 'general')
        discount_by_day_definition = Yito::Model::Rates::DiscountByDayDefinition.create(name: 'general', description: 'Descuento por días general')
      end  

    end
    

    # --------- Menus --------------------
    
    #
    # It defines the admin menu menu items
    #
    # @return [Array]
    #  Menu definition
    #
    def menu(context={})
      
      app = context[:app]

      menu_items = [                    
                    ]                      
    
    end  

    # ========= Routes ===================
            
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [                                             
               ]
        
    end
    
  end
end