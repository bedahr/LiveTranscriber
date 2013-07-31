module Core
  class Extension

    cattr_accessor(:all_extensions) { [] }

    attr_accessor :path, :app, :active, :init_path, :routes_path, :views_path, :assets_paths

    def initialize(path, app)
      @path   = path
      @app    = app
      @active = false

      @init_path     = File.join(Rails.root, path, "config/init.rb")
      @routes_path   = File.join(Rails.root, path, "config/routes.rb")
      @views_path    = File.join(Rails.root, path, "views/")
      @assets_paths  = Dir.glob(File.join(Rails.root, path, "assets/*"))

      self.class.all_extensions << self
    end

    def name
      @name ||= path.split('/').last.titlecase
    end

    def category
      @category ||= path.split('/').last(2).first.titlecase
    end

    def active?
      @active
    end

    def routes
      @routes ||= File.read(routes_path) rescue ""
    end

    def dirs
      %w(models helpers lib concerns controllers daemons vendor).
        collect { |dir| File.join(Rails.root, path, dir) }.
        select  { |dir| File.directory?(dir)     }
    end

    def activate
      Booter.say "Activating Extension: #{path}"

      append_autoload!
      append_assets!
      load_init!

      @active = true
    end

    def load_init!
      load(init_path) if File.exists?(init_path)
    end

    def append_autoload!
      # in development eager_load is not run but eager_load_paths are also used as autoload_paths
      # in production ther is no autoload so we need to put them in eager_load so they are loaded at boot
      dirs.each do |dir|
        app.config.eager_load_paths.unshift(dir)
      end
    end

    def append_assets!
      # adds assets folder to assets paths
      # adds entry point file named same as the extension
      # which should require other files
      # which will require separate link/script tag
      # if not, then other files can be require by main application.js/css

      Booter.say "Appending Assets Path #{assets_paths.join(' # ')}"

      Rails.application.config.assets.paths       |= assets_paths
      Rails.application.config.assets.precompile  << /(?:\/|\\|\A)(#{name.tableize})\.(css|js)$/
    end

    def placeholders
      Dir.glob(File.join(views_path, 'placeholders/**/*'))
    end

    def self.activate(*args)
      new(*args).activate
    end

    def self.inject_routes!(routes)
      Booter.say "Injecting Extensions Routes"

      all_extensions.each do |extension|
        unless extension.routes.blank?
          routes.instance_eval(extension.routes)
        end
      end
    end

    def self.append_view!(klass, kaller)
      kaller_path   = Pathname.new(kaller.first.split(/:\d+:in/).first)
      relative_path = kaller_path.ascend { |path| break(path) if path.basename.to_s == 'controllers' }.try(:dirname) || return
      view_path     = relative_path + "views"

      Booter.say "Appending View Path #{view_path}"

      if File.directory?(view_path.to_s)
        klass.append_view_path(view_path.to_s)
      end
    end

    def self.activate_many!
      raise "no block given" unless block_given?

      extensions = Set.new
      yield extensions

      extensions.each do |path|
        activate(File.join('code', path), LiveTranscriber::Application)
      end

      extensions
    end

    def self.active?(name)
      all_extensions.select(&:active?).collect(&:name).include?(name.to_s)
    end

  end
end

# extensions initializer needs to be loaded by hand so its before autoload/eager paths are frozen
initializer = File.join( Rails.root, "config", "initializers", "extensions.rb" )
require initializer if File.exists?(initializer)
