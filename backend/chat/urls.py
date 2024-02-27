from django.urls import path,include
from . import views

urlpatterns = [
    path('<str:roomname>/',views.showRoom),
    
]
