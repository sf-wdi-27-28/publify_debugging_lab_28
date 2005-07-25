class Theme
  cattr_accessor :cache_theme_lookup
  @@cache_theme_lookup = false

  attr_accessor :name, :path

  def initialize(name, path)
    @name, @path = name, path
  end
  
  def layout
    "../../themes/#{name}/layouts/default"
  end

  def description
    readme = File.read("#{path}/about.markdown")
    HtmlEngine.transform(readme, "markdown smartypants")
  end
  
  def self.themes_root
    RAILS_ROOT + "/themes"
  end

  def self.current_theme_path
    "#{themes_root}/#{config[:theme]}"
  end

  def self.current
    theme_from_path(current_theme_path)
  end
  
  def self.theme_from_path(path)
    name = path.scan(/[\w_]+$/).flatten.first
    self.new(name, path)
  end

  def self.find_all
    installed_themes.inject([]) do |array, path|
      array << theme_from_path(path)
    end
  end

  def self.installed_themes
    cache_theme_lookup ? @theme_cache ||= search_theme_directory : search_theme_directory
  end  

  def self.search_theme_directory
    Dir["#{themes_root}/[_a-z]*"].collect do |file|
      file if File.directory?(file)      
    end.compact
  end  
end
