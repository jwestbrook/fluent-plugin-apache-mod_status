# Fluent::Plugin::Apache::ModStatus

Collect Apache stats from the mod_status Module

## Installation

```ruby
fluent-gem install fluent-plugin-diskusage
```
or

```ruby
/usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-diskusage
```

## Usage

`refresh_interval` is an optional parameter, by default the plugin will poll every 2 minutes (120 seconds)

```
<source>
	type					apache_modstatus
	url						http://localhost/server-status/?auto
	tag						apache.server_status
	refresh_interval        30
</source>
```

### Record Format

Your record format might vary depending on what extensions and options are turned on in your config. The plugin looks at the machine readable mod_serverstatus output and parses all the "Label: VALUE" lines and outputs them in the record

```
	"serverversion"                => "Apache/2.4.16"
	"servermpm"                    => "prefork"
	"server_built"                 => "Aug 13 2015 23:52:13"
	"currenttime"                  => "Friday, 18-Sep-2015 14:40:21 PDT"
	"restarttime"                  => "Sunday, 13-Sep-2015 03:20:23 PDT"
	"parentserverconfiggeneration" => "5"
	"parentservermpmgeneration"    => "4"
	"serveruptimeseconds"          => "472798"
	"serveruptime"                 => "5 days 11 hours 19 minutes 58 seconds"
	"load1"                        => "0.31"
	"load5"                        => "0.21"
	"load15"                       => "0.21"
	"total_accesses"               => "1205397"
	"total_kbytes"                 => "44430012"
	"cpuuser"                      => "233.95"
	"cpusystem"                    => "38.8"
	"cpuchildrenuser"              => "5243.08"
	"cpuchildrensystem"            => "8685.85"
	"cpuload"                      => "3.00375"
	"uptime"                       => "472798"
	"reqpersec"                    => "2.5495"
	"bytespersec"                  => "96227.8"
	"bytesperreq"                  => "37743.9"
	"busyworkers"                  => "35"
	"idleworkers"                  => "3"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jwestbrook/fluent-plugin-apache-modstatus.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

