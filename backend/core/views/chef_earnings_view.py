from django.contrib.auth import get_user_model
from django.db.models import Sum
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from core.models import Order   # FIXED import

User = get_user_model()

class ChefEarningsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        role = getattr(request.user, "role", None)
        if role != "chef":
            return Response({"error": "Only chefs can access this endpoint."}, status=403)

        orders = Order.objects.filter(meal__chef=request.user)
        agg = orders.aggregate(total=Sum("total_price"))
        total_earnings = float(agg["total"] or 0)

        data = {
            "chef_id": request.user.id,
            "chef_name": request.user.get_username(),
            "total_orders": orders.count(),
            "total_earnings": total_earnings,
        }
        return Response(data)
