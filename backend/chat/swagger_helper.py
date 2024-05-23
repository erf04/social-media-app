from drf_yasg import openapi
from api.swagger_helper import user_serialized
from api.swagger_helper import authorization_param

group_serialized=openapi.Schema(
    type=openapi.TYPE_OBJECT,
    properties={
        'id': openapi.Schema(type=openapi.TYPE_INTEGER),
        "name":openapi.Schema(type=openapi.TYPE_STRING),
        "creator":user_serialized,
        "creation_date":openapi.Schema(type=openapi.TYPE_STRING),
        "participants":openapi.Schema(
            type=openapi.TYPE_ARRAY,
            items=user_serialized,
        ),
        "image":  openapi.Schema(type=openapi.TYPE_STRING,description="url of the image in backend side"),
        "admins":openapi.Schema(
            type=openapi.TYPE_ARRAY,
            items=user_serialized,
        ),

    }
)

private_chat_serialized=openapi.Schema(
    type=openapi.TYPE_OBJECT,
    properties={
        'id':openapi.Schema(type=openapi.TYPE_INTEGER),
        'creator':user_serialized,
        'the_other':user_serialized
    }

)