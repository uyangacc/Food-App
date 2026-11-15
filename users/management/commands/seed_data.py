from django.core.management.base import BaseCommand
from foodApp.models import Category, Difficulty, MealType


class Command(BaseCommand):
    help = "Анхны өгөгдөл оруулна"

    def handle(self, *args, **kwargs):
        categories = ["Шөл", "Үндсэн хоол", "Салад", "Амттан", "Ундаа"]
        difficulties = ["Хялбар", "Дунд", "Хэцүү"]
        meal_types = ["Өглөөний цай", "Үдийн хоол", "Оройн хоол", "Зууш"]

        for name in categories:
            Category.objects.get_or_create(name=name)
        for name in difficulties:
            Difficulty.objects.get_or_create(name=name)
        for name in meal_types:
            MealType.objects.get_or_create(name=name)

        self.stdout.write(self.style.SUCCESS("Өгөгдөл бэлэн боллоо!"))