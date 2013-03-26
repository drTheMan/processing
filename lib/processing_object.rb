require File.expand_path(File.join(File.dirname(__FILE__), 'class_options'))

module ProcessingObject

	include ClassOptions

	def object_options
		options[:object] || {}
	end

	def object
		@object_wrapper ||= ObjectWrapper.new(object_options)
	end

	class ObjectWrapper
		include ClassOptions

		def x
			options[:x] || 0
		end

		def y
			options[:y] || 0
		end

		def width
			options[:width] || 100
		end

		def height
			options[:height] || 100
		end

		def rotation
			options[:rotation] || 0.0
		end
	end # of class ObjectWrapper

end # of module ProcessingObject