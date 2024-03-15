from django.urls import path,include
from . import views

urlpatterns = [
    path('groups/',views.GroupApiView.as_view()),
    path('pv/',views.PrivateRoomView.as_view()),
    path('groups/add/',views.add_participants_to_group),
    path('get-users/',views.get_followers_and_followings),
    path('groups/filter',views.filter_groups),
    path('pv/filter',views.filter_pv),
    path('message/delete/',views.delete_message),
    
]
