from rest_framework import serializers
from api.models import Group,User,Message,CommentContainer,PrivateChat,GroupAdmin
from api.serializers import UserSerializer,PostSerializer
from api.models import User

class GroupAdminSerializer(serializers.ModelSerializer):
    user=UserSerializer(many=False)
    supervisor=UserSerializer(many=False)
    class Meta:
        model=GroupAdmin
        fields=('user', 'supervisor','is_staff')


class GroupSerializer(serializers.ModelSerializer):
    creator=UserSerializer(many=False,required=False)
    creation_date = serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S")
    participants=UserSerializer(many=True,required=False)
    admins=GroupAdminSerializer(many=True)
    class Meta:
        model=Group
        fields=('id','name','creator','creation_date','participants','image','admins')


    def get_admins(self,obj):
        return list(User.objects.filter(group_adminship__group=obj).values_list('id',flat=True))



class CommentContainerSerializer(serializers.ModelSerializer):
    # messages=MessageSerializer(many=True,required=False)
    class Meta:
        model=CommentContainer
        fields=('id','messages')



# class MessageChatField(serializers.RelatedField):
    
#     def to_representation(self, value):
#         if isinstance(value, Group):
#             serializer=GroupSerializer(value)
#         elif isinstance(value,CommentContainer):
#             serializer="CommentContainerSerializer"()
#         return serializer
    

class MessageSerializer(serializers.ModelSerializer):
    sender=UserSerializer(many=False,required=False)
    timestamp=serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S",read_only=True)
    liked_by=UserSerializer(many=True, required=False)
    saved_by=UserSerializer(many=True,required=False)
    reply_to=serializers.SerializerMethodField()
    class Meta:
        model=Message
        fields=('id','sender','reply_to','liked_by','saved_by','body','timestamp')

    def get_reply_to(self, obj:Message):
        if obj.reply_to:
            serializer = self.__class__(obj.reply_to)
            return serializer.data
        else:
            return None


class PrivateChatSerializer(serializers.ModelSerializer):
    creator=UserSerializer(many=False)
    the_other=UserSerializer(many=False)
    class Meta:
        model=PrivateChat
        fields=('id','creator','the_other')


class CompleteUserSerializer(serializers.ModelSerializer):
    followers_count=serializers.SerializerMethodField()
    followings_count=serializers.SerializerMethodField()
    class Meta:
        model = User
        fields=("id","username","email","image","followers_count","followings_count")

    def get_followers_count(self,obj:User):
        return User.objects.filter(followings__followed=obj).count()

    
    def get_followings_count(self,obj:User):
        return User.objects.filter(followers__follower=obj).count()
        


