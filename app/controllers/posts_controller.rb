class PostsController < ApplicationController
	before_action :find_post ,only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except:[:index, :show]

  def index
  	@posts = Post.all.order("created_at DESC")


  end

  def show
  	@post = Post.find(params[:id])
    @post = Post.find_by(id: params[:id])
    # 変数@likes_countを定義
    #モデルにリレーションを作ることでLikes.findなどとアクセスしなくても
    #以下の形でpostに紐づくlikeのレコードを取得することができる。
    #また、countメソッドを使うとレコードがない場合に0となってしまうので、countはviewで描画時に行う。
    #Railsでは0の扱いが難しいため。

    #⬇︎サインインしてない = current_userがnilなので、エラーになってしまう。⬇︎
      #@likes_count = Like.where(post_id: @post.id).count
      @likes = @post.likes


    #自分がいいね！したレコードがあるかどうかのチェック。
    #current_user&.idの&(アンパサンド)がないとcurrent_userがnilのときにエラーがおきる。
    @my_like = @likes.find_by_user_id(current_user&.id)
  end

  def new
  	@post = current_user.posts.build

  end

  def create

  	@post = current_user.posts.build(post_params)
  	if @post.save
  		redirect_to post_path(@post)
  	else
  		render 'new'
  	end
  end

  def edit
  	
  end

  def update
  	if @post.update(post_params)
  		redirect_to post_path
  	else
  		render 'edit'
  	end
  end

  def destroy
  	@post.destroy
  	redirect_to root_path
  end



  private
  def post_params													
  	params.require(:post).permit(:title, :description, :image)
  end

  def find_post
  	@post = Post.find(params[:id])
  end

end
