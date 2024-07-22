# social-media-app
social-media-app is a **social media platform** similar to Instagram, developed using *Django* for the backend, *Vue.js* for the web frontend, and *Flutter* for the mobile frontend. The application allows users to follow each other, view profiles, create posts, join groups, and engage in private chats. The chat functionality includes features like replying to messages, sending images, and setting group admins. Note that this project is still under development and is not yet feature-complete.

## features 
+ **User Authentication**: Sign up, login, and logout functionalities with jwt authentication.
+ **User Profiles**: View and edit profiles, follow and unfollow users.
+ **Posts**: Create, edit, and delete posts; view posts from followed users.
+ **Groups**: Join and leave groups, create new groups, group admin features.
+ **Private Chat**: One-on-one messaging, group chats, reply to messages, send images, set admins for groups.

## Technologies Used
**Backend**: [Django](https://docs.djangoproject.com/en/5.0/).

**Web Frontend**: [Vue.js](https://vuejs.org/guide/introduction.html).

**Mobile Frontend**: [Flutter](https://docs.flutter.dev/).

## installation

+ clone the repository:

``` bash 
git clone https://github.com/erf04/django-vue.git
cd django-vue
```
**notice: in each part first you must return to the main directory of project (`django-vue` directory)**
#### backend
```bash
cd backend
python3 -m pip install -r requirements.txt
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8000
```

#### Web Frontend (Vue.js)

```bash
cd frontend
npm i
npm run serve
```

#### Mobile Frontend (Flutter)
```bash
cd AppFlutter
flutter pub get
flutter run
```

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request for any improvements.

## Contact
For any questions or feedback, please reach out to `erfank20041382@gmail.com` .
