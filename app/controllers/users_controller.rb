class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :friends, :add_friend, :add_friends_by_name]
  # before_action :validate_user, only: [:update, :destroy]
  # before_action :validate_type, only: [:create, :update]

  def index
    users = User.all
    render json: users
  end

  def show
    render json: @user
  end

  def create
    data = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    Rails.logger.error params.to_yaml
    user = User.where(full_name: data[:full_name]).first
    if user
      user.errors.add(data[:full_name], 'Username already exist, try a new one')
      render_error(user, 403) and return
    end

    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render_error(user, :unprocessable_entity)
    end
  end

  def update
    if @user.update_attributes(user_params)
      render json: @user, status: :ok
    else
      render_error(@user, :unprocessable_entity)
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  # return all friends of the user
  def friends
    friends_list=[]
    @user.friends.each { |id| friends_list << User.find(id) }
    render json: friends_list
  end

  #add friends for a user by name
  def add_friend
    begin
      friend_id=params['data']['attributes']['id'].to_s
      friend=User.find(friend_id)
      if @user.friends.to_a.find_index(friend_id).nil?

        logger.debug @user.friends.to_s
        @user.friends << friend.id
        if @user.save
          render json: @user, status: :ok
        else
          render_error(@user, :unprocessable_entity)
        end
      else
        user = User.new
        user.errors.add(friend_id, "Is friend already with the provided user")
        render_error(user, 409) and return
      end
    rescue ActiveRecord::RecordNotFound
      user = User.new
      user.errors.add(friend_id, "Wrong friend ID provided")
      render_error(user, 404) and return
    end
  end

  #add friends for a user
  def add_friends_by_name
    begin
      friend_name=params['data']['attributes']['full-name'].to_s
      friend=User.find_by_full_name(friend_name)
      if @user.friends.to_a.find_index(friend.id.to_s).nil?
        @user.friends << friend.id
        if @user.save
          render json: @user, status: :ok
        else
          render_error(@user, :unprocessable_entity)
        end
      else
        user = User.new
        user.errors.add(friend_name, "Is friend already with the provided user")
        render_error(user, 409) and return
      end
    rescue ActiveRecord::RecordNotFound
      user = User.new
      user.errors.add(friend_name, "Wrong friend name provided")
      render_error(user, 404) and return
    end
  end


  private

  def set_user
    begin
      @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound
      user = User.new
      user.errors.add(:id, "Wrong ID provided")
      render_error(user, 404) and return
    end
  end

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end


