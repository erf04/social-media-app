from rest_framework import serializers
from .models import *
from datetime import datetime
from rest_framework.request import Request
class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model=Task
        fields="__all__"



class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model=User
        fields = ['id','username','email','image']


# class FollowerSerializer(serializers.ModelSerializer):
#     followers=UserSerializer(read_only=True,many=True)
#     following=UserSerializer(read_only=True,many=True)
#     class Meta:
#         model = Follower
#         fields= ['followers', 'following']



class PostSerializer(serializers.ModelSerializer):

    author=UserSerializer(many=False,required=False)
    created_at = serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S")
    liked_by=UserSerializer(many=True)
    saved_by=UserSerializer(many=True)
    # is_liked_by_user=serializers.SerializerMethodField()
    class Meta:
        model = Post
        fields = ["title","author","description","content","created_at","liked_by","saved_by"]


    def save(self,**kwargs):
        author=kwargs.get("author")
        creation_date=datetime.now()
        self.validated_data['author']=author
        self.validated_data['created_at']=creation_date
        return super().save()  # Call the parent's save() method



class FollowerSerializer(serializers.ModelSerializer):
    follower=UserSerializer(many=False)
    followed=UserSerializer(many=False)
    class Meta:
        model = Follower
        fields=('follower','followed')


        