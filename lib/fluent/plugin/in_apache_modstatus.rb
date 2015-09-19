class Fluent::ApacheModStatus < Fluent::Input
	Fluent::Plugin.register_input('apache_modstatus',self)

	# Define `router` method to support v0.10.57 or earlier
	unless method_defined?(:router)
		define_method("router") { Fluent::Engine }
	end
	
	config_param :tag,	:string
	config_param :url,	:string
	config_param :refresh_interval,	:integer, :default => 120

	def configure(conf)
		super
		require 'net/http'
		require 'uri'
	end

	def start
		super
		@watcher = Thread.new(&method(:run))
	end

	def run
		while true
			output
			sleep @refresh_interval
		end
	end

	def output
		
		record = {}

		page_content = Net::HTTP.get(URI.parse(@url))
		status_values = page_content.lines.map(&:chomp)
		status_values.each do |item|
			if item.include? "Scoreboard: "
				
			elsif item.include? ": "
				values = item.split(": ")
				values[0].downcase!
				values[0].gsub!(/ /,"_")
				if values[1].match(/[^A-z]+/)
					record[values[0]] = values[1].to_f
				else
					record[values[0]] = values[1]
				end
			end
		end
		
	
		time = Fluent::Engine.now
		router.emit(tag,time,record)
	end
	
	def shutdown
		@watcher.terminate
		@watcher.join

	end
end
