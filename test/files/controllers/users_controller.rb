# ユーザ情報を管理するコントローラ
# @openapi [3.0.2]
#   title: user api
#   version: 1.0.0
# @path /users
# @description aa
class UsersController

  # this method is so long
  # @path /path
  # @summary summary comment
  # @method GET
  # @tags [A,B,C]
  # @operation_id test
  # @request_bodies [Sample][application/json][required]
  #   this request body is sample.
  # @responses [Sample][application/json][200]
  #   this response is sample.
  # @request_parameters [Sample][path][name][required]
  #   this parameter is sample.
  # @securities [OAuth2]
  #   - read
  #   - write
  # @security_schemas OAuth2
  #   type: oauth2
  #   flows:
  #     authorizationCode:
  #       authorizationUrl: https://example.com/oauth/authorize
  #       tokenUrl: https://example.com/oauth/token
  #       scopes:
  #         read: Grants read access
  #         write: Grants write access
  #         admin: Grants access to admin operations
  # @schemas [Sample]
  #   type: object
  #   properties:
  #     number:
  #       type: number
  # @deprecated
  def index
  end

  # ユーザ情報
  # @path /:id
  # @method GET
  # @tags [A]
  # @responses [Sample][application/json][200]
  #   test
  #   this response so long time
  def show
  end

  private


end