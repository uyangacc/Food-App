from django.urls import path, include
from rest_framework.routers import SimpleRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import RegisterView, FavoriteViewSet
from .lookup_views import CategoryViewSet, DifficultyViewSet, MealTypeViewSet

router = SimpleRouter()
router.register("favorites", FavoriteViewSet, basename="favorite")
router.register("categories", CategoryViewSet)
router.register("difficulties", DifficultyViewSet)
router.register("meal-types", MealTypeViewSet)

urlpatterns = [
    path("register/", RegisterView.as_view()),
    path("login/", TokenObtainPairView.as_view()),
    path("token/refresh/", TokenRefreshView.as_view()),
    path("", include(router.urls)),
]