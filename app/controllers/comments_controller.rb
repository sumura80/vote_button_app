class CommentsController < ApplicationController
	before_action :find_post
	before_action :find_comment ,only:[:show, :edit, :update, :destroy]
	before_action :authenticate_user!

  # Post/showではcommentsコントローラのshowは動かないので、@my_voteはposts::showへ
	# def show
	# 	@comment = Comment.find(params[:id])
  #   @comment = Comment.find_by(id: params[:id])
  #   # 変数@likes_countを定義
  #   #モデルにリレーションを作ることでLikes.findなどとアクセスしなくても
  #   #以下の形でpostに紐づくlikeのレコードを取得することができる。
  #   #また、countメソッドを使うとレコードがない場合に0となってしまうので、countはviewで描画時に行う。
  #   #Railsでは0の扱いが難しいため。
  #
  #   #⬇︎サインインしてない = current_userがnilなので、エラーになってしまう。⬇︎
  #   #@likes_count = Like.where(post_id: @post.id).count
  #   @votes = @comment.votes
  #
  #
  #   #自分がいいね！したレコードがあるかどうかのチェック。
  #   #current_user&.idの&(アンパサンド)がないとcurrent_userがnilのときにエラーがおきる。
  #   @my_vote = @votes.find_by(id:current_user.id)
  #
	# end

	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.create(post_params)
		@comment.user_id = current_user.id

		if @comment.save
			redirect_to post_path(@post)
		else
			render 'new'
		end
	end

	# def edit
	# end


	# def update
	# 	if @comment.save
	# 	redirect_to post_comment_path(@post)
 #  	else
	# 	render 'edit'
 #  	end
 # end


 	def destroy
 		@comment.destroy
 		redirect_to post_path(@post)
 	end


	private

	def post_params
		params.require(:comment).permit(:content)
	end

	def find_post
		@post = Post.find(params[:post_id])

	end

	def find_comment
		@comment = @post.comments.find(params[:id])
	end


end
