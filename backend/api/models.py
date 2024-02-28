from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.

class Task(models.Model):
    title=models.CharField(max_length=100)
    description=models.TextField()
    completed=models.BooleanField(default=False)

    def __str__(self) -> str:
        return self.title
    


class User(AbstractUser):
    image=models.ImageField(upload_to='profile/', blank=True, null=True,default='default/userProfile/user.png')
    channel_name=models.CharField(max_length=1000,null=True,blank=True)
    


class Follower(models.Model):
    follower=models.ForeignKey(User, on_delete=models.CASCADE, related_name="followers")
    followed=models.ForeignKey(User, on_delete=models.CASCADE, related_name="followed")
    creation_date=models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('follower', 'followed')  # A user can't follow the same person more than once
        def __str__(self) -> str:
            return f"{self.follower} follows {self.followed}"
        

#for likes ,saves and forwards
class Content(models.Model):
    liked_by=models.ManyToManyField(User,related_name='likes',blank=True,null=True)
    saved_by=models.ManyToManyField(User,related_name='saves',blank=True,null=True)

    class Meta:
        abstract=True


# users can like , save and forward a post too    
class Post(Content):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    content=models.FileField(upload_to='posts/')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self) -> str:
        return f"Post by {self.author}: {self.title}"
    



class Chat(models.Model):
    creation_date=models.DateTimeField(auto_now_add=True)
    creator=models.ForeignKey(User,on_delete=models.CASCADE,related_name='created_chats')


    class Meta:
        abstract=True




class Message(Content):
    related_chat=models.ForeignKey(Chat,on_delete=models.CASCADE,related_name="messages")
    sender = models.ForeignKey(User,on_delete=models.CASCADE,related_name= "sent_messages")
    body = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    reply_to=models.ForeignKey('self',on_delete=models.CASCADE,null=True,blank=True)  # for replying to a message

    class Meta:
        abstract=True
    
    def __str__(self):
        return f"Message by {self.sender} at {self.timestamp}"
    

# forward is a message about a content
class Forward(Message):
    content=models.ForeignKey(Content,on_delete=models.CASCADE,related_name='forwards')

class CommentContainer(Chat):
    related_post=models.OneToOneField(Post, on_delete=models.CASCADE, primary_key=True,related_name= 'comment_container')


class Group(Chat):
    paticipants=models.ManyToManyField(User,blank=True)
    name=models.CharField(max_length=256)


class PrivateChat(Chat):
    the_other=models.ForeignKey(User,on_delete=models.CASCADE,related_name="private_chats")

