#!/usr/bin/ruby1.8

# system requirements:
# apt-get install ruby-gnome2
# apt-get install libgail-gnome-module

require 'panelapplet2'
require 'gnome2'
require 'net/http'

OAFIID = "OAFIID:GNOME_AdslWatcherApplet"
OAFIID_Factory = "OAFIID:GNOME_AdslWatcherApplet_Factory"
TITLE = "ADSL Watcher Applet"

class WatcherLabel < Gtk::Label
  def initialize(modem_ip)
    super nil

    @modem_ip = modem_ip
    refresh_label
    signal_connect_after('show') { |w, e| start }
    signal_connect_after('hide') { |w, e| stop }
    show
  end

  def start
    @tid = Gtk::timeout_add(30000) { refresh_label; true }
  end

  def stop
    unless @tid.nil?
      Gtk::timeout_remove(@tid)
      @tid = nil
    end
  end

  def refresh_label
    uri = URI.parse("http://#{@modem_ip}/info.html")
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new(uri.path)
      req.basic_auth 'admin', 'admin'
      response = http.request(req)
      if response.is_a? Net::HTTPSuccess
        if response.body =~ /<td class='hd'>Line Rate - Downstream \(Kbps\):<\/td>\n\s*<td>(\d+)<\/td>/m
          @downstream = $1
        end
        if response.body =~ /<td class='hd'>Line Rate - Upstream \(Kbps\):<\/td>\n\s*<td>(\d+)<\/td>/m
          @upstream = $1
        end
      end
    end

    self.label = "D:#{@downstream} U:#{@upstream}"
  end
end

init = proc do |applet, iid|
  if iid == OAFIID
    applet.add WatcherLabel.new("192.168.1.1")
    applet.show_all
    true
  else
    false
  end
end

PanelApplet.main OAFIID_Factory, TITLE, "0", &init
  
# vim:sw=2 ft=ruby:
