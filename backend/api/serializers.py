from rest_framework import serializers
from .models import *

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
    class Meta:
        model = Post
        fields = ["title","author","description","content","created_at"]


    def save(self,**kwargs):
        author=kwargs.get("author")
        self.validated_data['author']=author
        return super().save()  # Call the parent's save() method


        