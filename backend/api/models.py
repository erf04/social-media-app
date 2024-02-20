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
    image=models.ImageField(upload_to='profile/', blank=True, null=True)
    


class 
    
class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)


