module Sinatra
  module YitoExtension
    module Rates
      def self.registered(app)

        app.settings.views = Array(app.settings.views).push(
          File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 
          'views')))
        app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n')))      

        #
        # Rates console
        #
        app.get '/admin/console/rates', :allowed_usergroups => ['rates_manager','staff'] do
          load_page(:console_rates)
        end

      end
    end
  end
end