require 'yaml/store'
require_relative 'user'

class UserStore

	def self.all
		users = []
	  raw_users.each_with_index do |data, i|
	    users << User.new(data.merge("id" => i))
	  end
	  users
	end

	def self.database
    return @database if @database

    @database = YAML::Store.new('db/userdb')
    @database.transaction do
    	@database['users'] ||= []
    end
    @database
   end

   def self.raw_users
	  database.transaction do |db|
	    db['users'] || []
	  end
	end

	def self.create(data)
		database.transaction do
			database['users'] << data
		end
	end

	def self.delete(position)
		database.transaction do
			database['users'].delete_at(position)
		end
	end

	def self.find(id)
		raw_user = find_raw_user(id)
		User.new(raw_user.merge("id" => id))
	end

	def self.find_raw_user(id)
	  database.transaction do
	    database['users'][id]
	  end
	end

	def self.update(id, data)
		database.transaction do
			database['users'][id] = data
		end
	end

end
