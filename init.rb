

# Ruby unicode support
$KCODE = 'u'
require 'jcode'

# require gettext for ruby
begin
  # requires correct gettext version if Rails 1.2
  if Rails::VERSION::MAJOR >= 1 and Rails::VERSION::MINOR >=2
    gem 'gettext', '>= 1.9'
  else
    gem 'gettext', '<= 1.8.0'
  end
  require 'gettext/rails'
  require 'gettext/utils'
rescue
  raise StandardError.new("gettext could not be loaded: #{$!}")
end

# global methods
# all in the GettextLocalize module
require 'gettext_localize'

# locale used in the literals to be translated
GettextLocalize::original_locale = 'en'
# locale in case everything else fails
GettextLocalize::fallback_locale = 'ca'
# country if everything else fails
GettextLocalize::fallback_country = 'es'

# add this plugin as a new textdomain
# add this line to every localized plugin
GettextLocalize::plugin_bindtextdomain

# initialize country options from YML file
GettextLocalize::set_country_options

# base ruby class extensions
require 'gettext_localize_extend'
# rubyo on rails class extensions
require 'gettext_localize_rails'

# set paths with LC_MESSAGES
GettextLocalize::set_locale_paths

ActionView::Base.send(:include, GettextLocalize::Helper)
ActionController::Base.send(:include, GettextLocalize::Controller)
class ActionController::Base
  before_filter{|c| c.set_default_gettext_locale }
end
