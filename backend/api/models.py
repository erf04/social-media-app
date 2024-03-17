from django.db import models
from django.contrib.auth.models import AbstractUser
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey,GenericRelation
from datetime import datetime
import base64
from django.core.files.base import ContentFile
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
        






# users can like , save and forward a post too    
class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    content=models.FileField(upload_to='posts/')
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(auto_now=True)
    liked_by=models.ManyToManyField(User,related_name='post_likes',blank=True)
    saved_by=models.ManyToManyField(User,related_name='post_saves',blank=True)
    
    def __str__(self) -> str:
        return f"Post by {self.author}: {self.title}"
    



class AbstractChat(models.Model):
    creation_date=models.DateTimeField()
    # creator=models.ForeignKey(User,on_delete=models.CASCADE)


    class Meta:
        abstract=True


class Chat(AbstractChat):
    creator=models.ForeignKey(User,on_delete=models.CASCADE,related_name='created_chats')


class AbstractMessage(models.Model):
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    chat = GenericForeignKey('content_type', 'object_id')
    sender = models.ForeignKey(User,on_delete=models.CASCADE,related_name= "sent_messages")
    body = models.TextField()
    timestamp = models.DateTimeField()
    reply_to=models.ForeignKey('self',on_delete=models.CASCADE,null=True,blank=True)  # for replying to a message
    image=models.ImageField(upload_to="chat_images/",null=True,blank=True)


    class Meta:
        abstract=True
    
    def __str__(self):
        return f"Message by {self.sender} at {self.timestamp}"
    

class Message(AbstractMessage):
    
    sender = models.ForeignKey(User,on_delete=models.CASCADE,related_name= "sent_chat_messages")
    reply_to=models.ForeignKey('self',on_delete=models.SET_NULL,null=True,blank=True)  # for replying to a message
    liked_by=models.ManyToManyField(User,related_name='message_likes',blank=True)
    saved_by=models.ManyToManyField(User,related_name='message_saves',blank=True)

    def message_order(self,room,type):
        # chat_id=Group.objects.get(name=roomname,participants=user).id
        return Message.objects.filter(content_type__model=type,object_id=room.id).order_by('timestamp')
    
    @classmethod
    def create_from_base64(cls, base64_string:str):
    # Split the base64 string to get the content type and the data
        format, imgstr = base64_string.split(';base64,') 

        # Decode base64 data
        binary_data = base64.b64decode(imgstr)
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        filename = f'img_{timestamp}.jpg'
        # Create a new instance of YourModel and save the image
        instance = cls()
        instance.image.save(filename, ContentFile(binary_data),save=False)
        return instance

    

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
    image=models.ImageField(upload_to='GroupProfile',default='default/groupProfile/group.png', blank=True,null=True)


    def __str__(self) -> str:
        return f"id:{self.id}_name:{self.name}"



class PrivateChat(AbstractChat):
    creator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='private_chats_created')
    the_other=models.ForeignKey(User,on_delete=models.CASCADE,related_name="private_chats")
    messages=GenericRelation(Message)



class GroupAdmin(models.Model):
    supervisor=models.ForeignKey(User,on_delete=models.CASCADE,related_name= "group_admin_supervisor")
    is_staff=models.BooleanField(default=False)
    group=models.ForeignKey(Group,on_delete=models.CASCADE,related_name= 'admins')
    user=models.ForeignKey(User,on_delete=models.CASCADE,related_name= 'group_adminship')
    creation_time=models.DateTimeField()

    class Meta:
        unique_together = ('user', 'group')





class Game(models.Model):
    name=models.CharField(max_length=100)
    image=models.ImageField(upload_to='games')
    description=models.TextField()

    def __str__(self) -> str:
        return self.name
    

class GameLog(models.Model):
    player=models.ForeignKey(User,on_delete=models.CASCADE,related_name="game_logs")
    score=models.IntegerField(default=0)
    game=models.ForeignKey(Game,on_delete=models.PROTECT,related_name="player_logs")
    date=models.DateTimeField(default=datetime.now)




    


