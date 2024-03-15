from . import views
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainSlidingView,
    TokenRefreshSlidingView,
    TokenObtainPairView,
    TokenRefreshView
)
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path("hello/",views.hello,name="hello"),
    path("tasks/",views.getTasks,name="getTasks"),
    path("tasks/<int:id>/",views.getTask,name="getTask"),
    path("tasks/create/",views.createTask,name="createTask"),
    path('posts/all',views.show_allposts, name='all-posts'),
    path('posts/',views.showUserPosts,name="show-user-posts"),
    path('posts/create/',views.create_post),
    path('get-user/',views.getUserByUsername,name="getUser"),
    path('users/all/',views.getAllCompletedUsers.as_view()),
    path('users/filter/',views.filterCompletedUsers.as_view()),
    path('follower/add/',views.add_following),
    path('follower/remove/',views.remove_follower),
    

    
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)