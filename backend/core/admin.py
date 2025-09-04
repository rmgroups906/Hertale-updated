from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, Meal, Order, Product


class CustomUserAdmin(UserAdmin):
    model = CustomUser
    list_display = ("username", "email", "role", "is_staff", "is_active")
    list_filter = ("role", "is_staff", "is_active")
    fieldsets = UserAdmin.fieldsets + (
        (None, {"fields": ("role",)}),
    )
    add_fieldsets = UserAdmin.add_fieldsets + (
        (None, {"fields": ("role",)}),
    )


@admin.register(Meal)
class MealAdmin(admin.ModelAdmin):
    list_display = ("name", "chef")
    search_fields = ("name", "chef__username")


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ("meal", "customer", "total_price")
    search_fields = ("meal__name", "customer__username")


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ("name", "stock", "price")
    search_fields = ("name",)


# Register CustomUser separately
admin.site.register(CustomUser, CustomUserAdmin)
