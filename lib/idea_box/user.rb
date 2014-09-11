class User
	include Comparable

	def initialize(attributes = {})
	  @name 			 = attributes["name"]
	  @password    = attributes["password"]
	end

	def save
		UserStore.create(to_h)
	end

	def to_h
		{
			"name" => title,
			"password" => description,
		}
	end

end
