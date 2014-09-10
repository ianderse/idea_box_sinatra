require 'bundler'
require 'idea_box'

Bundler.require

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  set :public_folder, 'public'

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  get '/groups' do
    erb :groups, locals: {groups: IdeaStore.all_groups}
  end

  post '/groups' do
    IdeaStore.create_group(params[:group])
    redirect '/groups'
  end

  post '/update_groups' do
    IdeaStore.update_groups(params[:group])
    redirect '/groups'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea, groups: IdeaStore.all_groups}
  end

  get '/tag_sort' do
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.sort_by {|idea| idea.tags[0]}, idea: Idea.new(params)}
  end

  post '/' do
  	IdeaStore.create(params[:idea])
    redirect '/'
	end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/dislike' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.dislike!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/tag/:tag' do |tag|
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.find_all {|idea| idea.tags.include?(tag)}, idea: Idea.new(params)}
  end

  get '/group/:group' do |group|
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.find_all {|idea| idea.group.include?(group)}, idea: Idea.new(params)}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

end
