from drf_yasg import openapi

user_serialized=openapi.Schema(
                type=openapi.TYPE_OBJECT,
                properties={

                    "id":openapi.Schema(
                        type=openapi.TYPE_INTEGER
                    ),
                    "username":openapi.Schema(
                        type=openapi.TYPE_STRING
                    ),
                    "email":openapi.Schema(
                        type=openapi.TYPE_STRING
                    ),
                    "image":openapi.Schema(
                        type=openapi.TYPE_STRING
                    ),

                }   
)

post_serialized=openapi.Schema(
    type=openapi.TYPE_OBJECT,
    properties={
        "title":openapi.Schema(type=openapi.TYPE_STRING),
        "author":user_serialized,
        "content":openapi.Schema(type=openapi.TYPE_FILE),
        "description":openapi.Schema(type=openapi.TYPE_STRING),
        "liked_by":openapi.Schema(
            type=openapi.TYPE_ARRAY,
            items=user_serialized
        ),              
        "saved_by":openapi.Schema(
            type=openapi.TYPE_ARRAY,
            items=user_serialized
        ),


    }
)

follower_serialized=openapi.Schema(
    type=openapi.TYPE_OBJECT,
    properties={
      "follower":user_serialized,
      "following":user_serialized, 
    }   
)

authorization_param=openapi.Parameter(
                "Authorization",
                openapi.IN_HEADER,
                description="access token",
                type=openapi.TYPE_STRING,
                required=True                
            )
