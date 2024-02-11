from . import views
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainSlidingView,
    TokenRefreshSlidingView,
    TokenObtainPairView,
    TokenRefreshView
)

urlpatterns = [
    path("hello/",views.hello,name="hello"),
    path("tasks/",views.getTasks,name="getTasks"),
    path("tasks/<int:id>/",views.getTask,name="getTask"),
    path("tasks/create/",views.createTask,name="createTask"),
    # path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    # path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
