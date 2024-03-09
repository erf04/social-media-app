from django.db import models
from django.contrib.auth.models import AbstractUser
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey,GenericRelation
# Create your models here.

class Task(models.Model):
    title=models.CharField(max_length=100)
    description=models.TextField()
    completed=models.BooleanField(default=False)

    def __str__(self) -> str:
        return self.title
    


class User(AbstractUser):
    image=models.ImageField(upload_to='profile/', blank=True, null=True,default='default/userProfile/user.png')
    
    @property
    def followers(self):
        return User.objects.filter(followers__followed__id=self.id)

    @property
    def followings(self):
        return User.objects.filter(followings__follower__id=self.id)


    def __str__(self) -> str:
        return f"{self.pk}:{self.username}"
    


class Follower(models.Model):
    follower=models.ForeignKey(User, on_delete=models.CASCADE, related_name="followings")
    followed=models.ForeignKey(User, on_delete=models.CASCADE, related_name="followers")
    creation_date=models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('follower', 'followed')  # A user can't follow the same person more than once
        def __str__(self) -> str:
            return f"{self.follower} follows {self.followed}"
        

#for likes ,saves and forwards
class AbstractContent(models.Model):
    liked_by=models.ManyToManyField(User,blank=True)
    saved_by=models.ManyToManyField(User,blank=True)

    class Meta:
        abstract=True




# users can like , save and forward a post too    
class Post(AbstractContent):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    content=models.FileField(upload_to='posts/')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    liked_by=models.ManyToManyField(User,related_name='post_likes',blank=True)
    saved_by=models.ManyToManyField(User,related_name='post_saves',blank=True)
    
    def __str__(self) -> str:
        return f"Post by {self.author}: {self.title}"
    



class AbstractChat(models.Model):
    creation_date=models.DateTimeField()
    creator=models.ForeignKey(User,on_delete=models.CASCADE)


    class Meta:
        abstract=True


class Chat(AbstractChat):
    creator=models.ForeignKey(User,on_delete=models.CASCADE,related_name='created_chats')


class AbstractMessage(AbstractContent):
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    chat = GenericForeignKey('content_type', 'object_id')
    sender = models.ForeignKey(User,on_delete=models.CASCADE,related_name= "sent_messages")
    body = models.TextField()
    timestamp = models.DateTimeField()
    reply_to=models.ForeignKey('self',on_delete=models.CASCADE,null=True,blank=True)  # for replying to a message

    class Meta:
        abstract=True
    
    def __str__(self):
        return f"Message by {self.sender} at {self.timestamp}"
    

class Message(AbstractMessage):
    
    sender = models.ForeignKey(User,on_delete=models.CASCADE,related_name= "sent_chat_messages")
    reply_to=models.ForeignKey('self',on_delete=models.CASCADE,null=True,blank=True)  # for replying to a message
    liked_by=models.ManyToManyField(User,related_name='message_likes',blank=True)
    saved_by=models.ManyToManyField(User,related_name='message_saves',blank=True)

    def message_order(self,room,type):
        # chat_id=Group.objects.get(name=roomname,participants=user).id
        return Message.objects.filter(content_type__model=type,object_id=room.id).order_by('timestamp')

    

# forward is a message about a content
class Forward(AbstractMessage):
    post=models.ForeignKey(Post,related_name="forward",on_delete=models.CASCADE)
    liked_by=models.ManyToManyField(User,related_name='forward_likes',blank=True)
    saved_by=models.ManyToManyField(User,related_name='forward_saves',blank=True)

class CommentContainer(AbstractChat):
    creator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='comment_containers_created')
    related_post=models.OneToOneField(Post, on_delete=models.CASCADE, primary_key=True,related_name= 'comment_container')
    messages=GenericRelation(Message)


class Group(AbstractChat):
    creator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='groups_created')
    participants=models.ManyToManyField(User,blank=True)
    name=models.CharField(max_length=256)
    messages=GenericRelation(Message)
    image=models.ImageField(upload_to='GroupProfile',default='default/groupProfile/group-profile.png', blank=True,null=True)



class PrivateChat(AbstractChat):
    creator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='private_chats_created')
    the_other=models.ForeignKey(User,on_delete=models.CASCADE,related_name="private_chats")
    messages=GenericRelation(Message)


