class PostsController < ApplicationController
    
    # GET /posts/all
    def index
        posts = Post.where(user_id: @current_user.id).or(Post.where(is_public: true))
            .select(:id, :title, :body, :user_id, :is_public, :is_draft, :created_at, :updated_at)
            .includes(:user)
            .order(created_at: :desc) # always order before paginate
            .page((params[:page] || 1).to_i)
            .per((params[:per_page] || 10).to_i)

        render_response({
            pagination: {
                page: posts.current_page,
                per_page: posts.limit_value,
                total_pages: posts.total_pages,
                total_count: posts.total_count
            },
            rows: posts.as_json(include: { user: { only: [:name] } })
        })
    end

    # POST /posts/create
    def create
        post = Post.new(post_params)
        post.user_id = @current_user.id
        if post.save
            render_response(post)
        else
            render_response({}, :unprocessable_entity, post.errors.full_messages.join(". "))
        end
    end

    # GET /posts/show/:id
    def show
        post = Post.find_by(id: params[:id], user_id: @current_user.id)
        if post
            render_response(post)
        else
            render_response({}, :not_found, I18n.t('post.not_found'))
        end
    end

    # PATCH /posts/update/:id
    def update
        post = Post.find_by(id: params[:id], user_id: @current_user.id)
        if post
          post.update(post_params)
          render_response(post)
        else
          render_response({}, :not_found, I18n.t('post.not_found'))
        end
    end

    # DELETE /posts/delete/:id
    def destroy
        post = Post.find_by(id: params[:id], user_id: @current_user.id)
        if post
          post.destroy
          render_response({}, :ok, I18n.t('post.deleted'))
        else
          render_response({}, :not_found, I18n.t('post.not_found'))
        end
    end

    private

    def post_params
        params.require(:post).permit(:title, :body, :is_public, :is_draft)
    end
end
