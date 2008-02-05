require 'gettext/utils'

# Tell ruby-gettext's ErbParser to parse .erb files as well
# See also http://zargony.com/2007/07/29/using-ruby-gettext-with-edge-rails/
GetText::ErbParser.init(:extnames => ['.rhtml', '.erb'])

namespace :gettext do

  desc "Update app pot/po files."
  task :updatepo => :environment do
    name = GettextLocalize::app_name
    version = GettextLocalize::app_name_version
    GetText.update_pofiles(name, Dir.glob("{app,lib,bin}/**/*.{rb,rhtml,erb,rjs}"), version)
  end

  desc "Create app mo files"
  task :makemo => :environment do
    GetText.create_mofiles(true, "po", "locale")
  end

  namespace :plugins do

    desc "Update pot/po files of all plugins."
    task :updatepo => :environment do
      GettextLocalize::each_plugin do |version,name,dir|
        version = name+" "+version
        GetText.update_pofiles(name, Dir.glob("#{dir}/**/*.{rb,rhtml,erb,rjs}"), version, File.join(dir,"po"))
      end
    end

    desc "Create mo files of all plugins."
    task :makemo => :environment do
      GettextLocalize::each_plugin do |version,name,dir|
        GetText.create_mofiles(true, File.join(dir,"po"), File.join(dir,"locale"))
      end
    end

  end
end
