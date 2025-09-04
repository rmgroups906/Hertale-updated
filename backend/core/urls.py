from django.urls import path
from .views.chef_earnings_view import ChefEarningsView
from .views.customer_views import CustomerDashboardView, ProductListView

urlpatterns = [
    path("api/chef/earnings/", ChefEarningsView.as_view(), name="chef-earnings"),
    path("api/customer/dashboard/", CustomerDashboardView.as_view(), name="customer-dashboard"),
    path("api/products/", ProductListView.as_view(), name="product-list"),
]
