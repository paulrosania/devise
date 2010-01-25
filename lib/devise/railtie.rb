require 'devise'
require 'action_controller/railtie'
require 'rails'

DEVISE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

module Devise
  class Railtie < Rails::Railtie
    railtie_name :devise

    def load_paths
      Dir["#{DEVISE_PATH}/app/{models,controllers,helpers}"]
    end

    initializer "devise.add_to_load_path", :after => :set_autoload_paths do |app|
      load_paths.each do |path|
        $LOAD_PATH << path
        require "active_support/dependencies"

        ActiveSupport::Dependencies.load_paths << path

        unless app.config.reload_plugins
          ActiveSupport::Dependencies.load_once_paths << path
        end
      end
    end

    initializer "devise.add_view_paths", :after => :initialize_framework_views do
      views = "#{DEVISE_PATH}/app/views"
      ActionController::Base.view_paths.concat([views]) if defined? ActionController
      ActionMailer::Base.view_paths.concat([views])     if defined? ActionMailer
    end
    
    initializer "devise.load_routes_and_warden_compat" do |app|
      require 'devise/rails/routes'
      require 'devise/rails/warden_compat'
    end
    
    initializer "devise.add_middleware", :before => :build_middleware_stack do |app|
      # Adds Warden Manager to Rails middleware stack, configuring default devise
      # strategy and also the failure app.
      app.config.middleware.use Warden::Manager do |config|
        Devise.configure_warden(config)
      end
    end

    initializer "devise.after_initialize" do |app|
      require "devise/orm/#{Devise.orm}"

      I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales', 'en.yml'))
    end
    
    initializer "devise.notify_done", :after => :disable_dependency_loading do |app|
      puts "=> Completed initialization"
    end
    
    
    # # Prepare dispatcher callbacks and run 'prepare' callbacks
    # initializer "action_dispatch.prepare_dispatcher" do |app|
    #   # TODO: This used to say unless defined?(Dispatcher). Find out why and fix.
    #   require 'rails/dispatcher'
    # 
    #   unless app.config.cache_classes
    #     # Setup dev mode route reloading
    #     routes_last_modified = app.routes_changed_at
    #     reload_routes = lambda do
    #       unless app.routes_changed_at == routes_last_modified
    #         routes_last_modified = app.routes_changed_at
    #         app.reload_routes!
    #       end
    #     end
    #     ActionDispatch::Callbacks.before { |callbacks| reload_routes.call }
    #   end
    # end
  end
end