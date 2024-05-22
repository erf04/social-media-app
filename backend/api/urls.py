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
    path('posts/all',views.show_allposts, name='all-posts'),
    # path('posts/',views.showUserPosts,name="show-user-posts"),
    path('posts/create/',views.create_post),
    path('get-user/',views.getUserByUsername,name="getUser"),
    path('users/all/',views.getAllCompletedUsers.as_view()),
    path('users/filter/',views.filterCompletedUsers.as_view()),
    path('follower/add/',views.add_following),
    path('follower/remove/',views.remove_follower),
    path('complete-user/me/',views.get_complete_user),
    path('posts/',views.PostAPIView.as_view()),
    path('post/add-like/',views.like_post),
    path('post/liked/',views.is_liked_by_user)
    

    
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)