module Users
  # ユーザの投稿を管理するコントローラ
  # @path /users/:user_id/posts
  # @description aa
  class PostsController

    # ユーザの投稿一覧
    # @summary 投稿一覧
    # @method GET
    # @response [200][Posts][application/json] 投稿一覧
    #   type: object
    #   properties:
    #     id:
    #       type: number
    #       example: 1
    #     text:
    #       type: string
    #       example: 初投稿
    # @response [400][][application/json] 入力値エラー
    #   type: object
    #   properties:
    #     errors:
    #       type: array
    #       items:
    #         type: string
    def index
    end

    # 投稿詳細
    # @path /:id
    # @method GET
    def show
    end

    # 投稿
    # @method POST
    # @response [201]
    def create
    end

    # 投稿編集
    # @method PATCH
    # @response [204]
    def update
    end
  end
end
