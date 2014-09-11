require 'yaml/store'
require_relative 'idea'

class IdeaStore

	def self.all_groups
		groups = []
	  raw_groups.each do |data|
	    groups << data
	  end
	end

	def self.raw_groups
	  group_database.transaction do |db|
	    db['groups'] || []
	  end
	end

	def self.group_database
		return @group_database if @group_database

    @group_database = YAML::Store.new("db/ideabox")

    @group_database.transaction do
    	@group_database['groups'] ||= []
    end

    @group_database
  end

  def self.create_group(data)
  	group_database.transaction do
  		group_database['groups'] << data
  	end
  end

	def self.update_groups(data)
		id = data["id"].to_i - 1
		name = data["name"]
		group_database.transaction do
			group_database['groups'][id]["name"] = name
			# group_database['groups'][id]["id"] = id + 1
		end
	end

	def self.delete_group(group)
		group_database.transaction do
			group_database['groups'].delete_at(group.to_i-1)
		end
	end

	def self.create(data)
		database.transaction do
			database['ideas'] << data
		end
	end

	def self.delete(position)
		database.transaction do
			database['ideas'].delete_at(position)
		end
	end

	def self.find(id)
		raw_idea = find_raw_idea(id)
		Idea.new(raw_idea.merge("id" => id))
	end

	def self.find_raw_idea(id)
	  database.transaction do
	    database['ideas'][id]
	  end
	end

	def self.all
		ideas = []
	  raw_ideas.each_with_index do |data, i|
	    ideas << Idea.new(data.merge("id" => i))
	  end
	  ideas
	end

	def self.raw_ideas
	  database.transaction do |db|
	    db['ideas'] || []
	  end
	end

	def self.update(id, data)
		database.transaction do
			database['ideas'][id] = data
		end
	end

	def self.database
     return @database if @database

    @database = YAML::Store.new('db/ideabox')

    @database.transaction do
    	@database['ideas'] ||= []
    end
    @database
   end

end
