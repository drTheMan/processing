module ClassOptions
	def initialize(_opts = {})
		@options = _opts
	end

	def options
		@options || {}
	end
end