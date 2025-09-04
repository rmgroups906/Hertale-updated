from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from core.models import Order, Product      # FIXED import
from core.serializers import ProductSerializer   # FIXED import
from django.db.models import Sum

class CustomerDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        role = getattr(request.user, "role", None)
        if role != "customer":
            return Response({"error": "Only customers can access this endpoint."}, status=403)

        orders = Order.objects.filter(customer=request.user)
        total_spent = float(orders.aggregate(total=Sum("total_price"))["total"] or 0)

        data = {
            "customer_id": request.user.id,
            "customer_name": request.user.username,
            "total_orders": orders.count(),
            "total_spent": total_spent,
        }
        return Response(data)

class ProductListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        products = Product.objects.filter(stock__gt=0)
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)
