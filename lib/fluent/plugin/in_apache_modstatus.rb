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

	def valid_float(value)
		!!Float(value) rescue false
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
#				Scoreboard Key:
#				"_" Waiting for Connection, "S" Starting up, "R" Reading Request,
#				"W" Sending Reply, "K" Keepalive (read), "D" DNS Lookup,
#				"C" Closing connection, "L" Logging, "G" Gracefully finishing,
#				"I" Idle cleanup of worker, "." Open slot with no current process				
				values = item.split(": ")
				scores = values[1].split(//)
				
				scoreboard = {
					"wait" => 0,
					"start" => 0,
					"read" => 0,
					"reply" => 0,
					"keepalive" => 0,
					"dns" => 0,
					"closing" => 0,
					"log" => 0,
					"graceful" => 0,
					"cleanup" => 0,
					"openslot" => 0
					}
				
				scores.each do |score|
					if score == "_"
						scoreboard["wait"] = scoreboard["wait"] + 1
					elsif score == "S"
						scoreboard["start"] = scoreboard["start"] + 1
					elsif score == "R"
						scoreboard["read"] = scoreboard["read"] + 1
					elsif score == "W"
						scoreboard["reply"] = scoreboard["reply"] + 1
					elsif score == "K"
						scoreboard["keepalive"] = scoreboard["keepalive"] + 1
					elsif score == "D"
						scoreboard["dns"] = scoreboard["dns"] + 1
					elsif score == "C"
						scoreboard["closing"] = scoreboard["closing"] + 1
					elsif score == "L"
						scoreboard["log"] = scoreboard["log"] + 1
					elsif score == "G"
						scoreboard["graceful"] = scoreboard["graceful"] + 1
					elsif score == "I"
						scoreboard["cleanup"] = scoreboard["cleanup"] + 1
					elsif score == "."
						scoreboard["openslot"] = scoreboard["openslot"] + 1
					end
				end
				
				scoreboard.each do |key,score|
					record["scoreboard_count_#{key}"] = score
				end
				
			elsif item.include? ": "
				values = item.split(": ")
				values[0].downcase!
				values[0].gsub!(/ /,"_")
				if valid_float(values[1])
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
