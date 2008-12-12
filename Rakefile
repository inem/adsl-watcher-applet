require 'fileutils'

desc "Install applet"
task :install do
  FileUtils.cp "adsl-watcher-applet.rb", "/usr/lib/gnome-panel/adsl-watcher-applet.rb"
  FileUtils.cp "GNOME_AdslWatcherApplet.server", "/usr/lib/bonobo/servers/GNOME_AdslWatcherApplet.server"
  FileUtils.cp "adsl-watcher-applet.png", "/usr/share/icons/hicolor/48x48/apps/adsl-watcher-applet.png"
  `gtk-update-icon-cache /usr/share/icons/hicolor/`
end

desc "Uninstall applet"
task :uninstall do
  FileUtils.rm "/usr/lib/gnome-panel/adsl-watcher-applet.rb"
  FileUtils.rm "/usr/lib/bonobo/servers/GNOME_AdslWatcherApplet.server"
  FileUtils.rm "/usr/share/icons/hicolor/48x48/apps/adsl-watcher-applet.png"
  `gtk-update-icon-cache /usr/share/icons/hicolor/`
end
