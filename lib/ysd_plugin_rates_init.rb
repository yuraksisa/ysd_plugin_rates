require 'ysd-plugins' unless defined?Plugins::Plugin
require 'ysd_plugin_rates_extension'

Plugins::SinatraAppPlugin.register :rates do

   name=        'rates'
   author=      'yurak sisa'
   description= 'Rates integration'
   version=     '0.1'
   
   sinatra_extension Sinatra::YitoExtension::Rates
   sinatra_extension Sinatra::YitoExtension::SeasonDefinitionManagement
   sinatra_extension Sinatra::YitoExtension::SeasonDefinitionManagementRESTApi
   sinatra_extension Sinatra::YitoExtension::SeasonManagement
   sinatra_extension Sinatra::YitoExtension::SeasonManagementRESTApi   
   sinatra_extension Sinatra::YitoExtension::FactorDefinitionManagement
   sinatra_extension Sinatra::YitoExtension::FactorDefinitionManagementRESTApi
   sinatra_extension Sinatra::YitoExtension::FactorManagement
   sinatra_extension Sinatra::YitoExtension::FactorManagementRESTApi   
   sinatra_extension Sinatra::YitoExtension::PriceDefinitionManagement
   sinatra_extension Sinatra::YitoExtension::PriceDefinitionManagementRESTApi
   sinatra_extension Sinatra::YitoExtension::PriceManagement
   sinatra_extension Sinatra::YitoExtension::PriceManagementRESTApi
   sinatra_extension Sinatra::YitoExtension::PromotionCodeManagement
   sinatra_extension Sinatra::YitoExtension::PromotionCodeManagementRESTApi

end