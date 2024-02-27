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
    


class Follower(models.Model):
    follower=models.ForeignKey(User, on_delete=models.CASCADE, related_name="followers")
    followed=models.ForeignKey(User, on_delete=models.CASCADE, related_name="followed")
    creation_date=models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('follower', 'followed')  # A user can't follow the same person more than once
        def __str__(self) -> str:
            return f"{self.follower} follows {self.followed}"
    
class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    content=models.FileField(upload_to='posts/')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self) -> str:
        return f"Post by {self.author}: {self.title}"

