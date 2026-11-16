from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=100, unique=True, verbose_name="Ангилал")

    def __str__(self):
        return self.name


class Difficulty(models.Model):
    name = models.CharField(max_length=100, unique=True, verbose_name="Хүндрэл")

    def __str__(self):
        return self.name


class MealType(models.Model):
    name = models.CharField(max_length=100, unique=True, verbose_name="Хоолны төрөл")

    def __str__(self):
        return self.name


class Recipe(models.Model):
    Нэр = models.CharField(max_length=255, verbose_name="Хоолны нэр")
    Тайлбар= models.TextField(verbose_name="Тайлбар")
    Найрлага = models.TextField(verbose_name="Орц найрлага")
    Заавар = models.TextField(verbose_name="Хийх заавар")
    Зураг = models.ImageField(upload_to='recipes/', blank=True, null=True, verbose_name="Зураг")
    Огноо = models.DateTimeField(auto_now_add=True, verbose_name="Үүсгэсэн огноо")
    Хугацаа = models.CharField(max_length=50, blank=True, null=True, verbose_name="Хийх хугацаа")
    Порц = models.PositiveIntegerField(default=2, verbose_name="Хүний тоо / Порц")

    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True)
    difficulty = models.ForeignKey(Difficulty, on_delete=models.SET_NULL, null=True, blank=True)
    meal_type = models.ForeignKey(MealType, on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self):
        return f"{self.Нэр}"