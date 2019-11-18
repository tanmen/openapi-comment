# @schemas [UserResponse]
#   allOf:
#     - $ref: '#/components/schemas/User'
#     - $ref: '#/components/schemas/Response'
# @schemas [User]
#   type: object
#   properties:
#     id:
#       type: number
#     name:
#       type: string
# @schemas [Response]
#   type: object
#   properties:
#     status:
#       type: string
#       enum:
#         - success
#         - error
