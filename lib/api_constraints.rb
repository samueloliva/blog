class ApiConstraints
	def initialize(options)
		@version = options[:version]
		@default = options[:version]
	end

	def matches?(req)
		@default || req.headers["Accept"].include?("applications/vnd.example.v#{@version}")
	end
end
