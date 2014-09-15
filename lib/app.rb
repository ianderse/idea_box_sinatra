require 'bundler'
require_relative './idea_box'

Bundler.require

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  set :public_folder, 'public'

  not_found do
    erb :error
  end

  # get '/db' do
  #   erb :db, layout: false
  # end

  get '/' do
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.sort, idea: Idea.new(params), user: params.fetch("name", '')}
  end

  get '/groups' do
    erb :groups, locals: {groups: IdeaStore.all_groups, user: params.fetch("name", '')}
  end

  post '/groups' do
    IdeaStore.create_group(params[:group])
    redirect "/groups?name=#{params[:groups][:user]}"
  end

  post '/update_groups' do
    IdeaStore.update_groups(params[:group])
    redirect "/groups?name=#{params[:groups][:user]}"
  end

  get '/search' do
    erb :index, locals: {
      groups: IdeaStore.all_groups,
      ideas: IdeaStore.all.find_all do |idea|
        idea.tags.include?(params[:search][:query].downcase) ||
        idea.group.downcase.include?(params[:search][:query].downcase) ||
        idea.title.downcase.include?(params[:search][:query].downcase) ||
        idea.description.downcase.include?(params[:search][:query].downcase)
      end,
      idea: Idea.new(params),
      user: params[:search][:user]}
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea, groups: IdeaStore.all_groups, user: params.fetch("name", '')}
  end

  get '/tag_sort' do
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.sort_by {|idea| idea.tags[0]}, idea: Idea.new(params), user:  params.fetch("name", '')}
  end

  get '/register' do
    erb :register, locals: {user:  params.fetch("name", '')}
  end

  get '/login' do
    erb :login, locals: {user:  params.fetch("name", '')}
  end

  get '/myideas' do
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.find_all {|idea| idea.user.include?(params.fetch("name", ''))}, idea: Idea.new(params), user: params.fetch("name", '')}
  end

  get '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :idea, locals: {idea: idea, groups: IdeaStore.all_groups, user: params.fetch("name", '')}
  end

  get '/tag/:tag' do |tag|
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.find_all {|idea| idea.tags.include?(tag)}, idea: Idea.new(params), user:  params.fetch("name", '')}
  end

  get '/group/:group' do |group|
    erb :index, locals: {groups: IdeaStore.all_groups, ideas: IdeaStore.all.find_all {|idea| idea.group.include?(group)}, idea: Idea.new(params), user:  params.fetch("name", '')}
  end

  post '/user' do
    UserStore.create(params[:user])
    redirect "/?name=#{params[:user][:name]}"
  end

  post '/' do
  	IdeaStore.create(params[:idea])
    redirect "/?name=#{params[:idea][:user]}"
	end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect "/?name=#{params[:like][:user]}"
  end

  post '/:id/dislike' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.dislike!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect "/?name=#{params[:dislike][:user]}"
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect "/?name=#{params[:idea][:user]}"
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect "/?name=#{params[:delete][:user]}"
  end

  delete '/groups/:group' do |group|
    IdeaStore.delete_group(group)
    redirect "/?name=#{params[:delete][:user]}"
  end

end
