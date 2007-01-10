

# Ruby unicode support
$KCODE = 'u'
require 'jcode'

# require gettext for ruby
begin
  # put this require in your environment.rb
  # uncomment it here if you don't mind a warning
  # require 'gettext/rails' unless ActionController::Base.respond_to?(:init_gettext)
  require 'gettext/rails'
  require 'gettext/utils'
rescue
  raise StandardError.new("gettext could not be loaded: #{$!}")
end


# global methods
# all in the GettextLocalize module
require 'gettext_localize'

# Fixme: Setting a Date to a datetime activerecord
# tries to save localized to_s

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
