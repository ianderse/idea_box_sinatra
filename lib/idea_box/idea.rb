class Idea
	include Comparable

	attr_reader :title, :description, :rank, :id, :tags

	def initialize(attributes = {})
	  @title 			 = attributes["title"]
	  @description = attributes["description"]
	  @rank 		   = attributes["rank"] || 0
	  @id 				 = attributes["id"]
	  @tags				 = split(attributes["tags"]).sort
	end

	def split(tag)
		if tag.is_a?(Array)
			tag
		elsif tag.nil?
			[]
		elsif tag.empty?
			[]
		else
			tag.delete(' ').split(',')
		end
	end

	def save
		IdeaStore.create(to_h)
	end

	def to_h
		{
			"title" => title,
			"description" => description,
			"rank" => rank,
			"tags" => tags
		}
	end

	def like!
		@rank += 1
	end

	def dislike!
		@rank -= 1
	end

	def <=>(other)
		other.rank <=> rank
	end

end
