from django.urls import path
from . import views

urlpatterns = [
    path('',views.getRoutes),
    path('register/',views.register),
    path('login/',views.login),
    path('getPopularStocks/',views.getPopularStocks),
    path('getFreeCashFlow/',views.getFreeCashFlow),
    path('getStockNews/',views.getStockNews),
    path('getStockPressRelease/',views.getStockPressRelease),
    path('getAnalystEstimates/',views.getAnalystEstimates),
    path('getStockNumberOfShares/',views.getStockNumberOfShares),
    path('getValueAtRiskAndVolatilty/',views.getValueAtRiskAndVolatilty),
    path('getCompanyInsiderTrading/' , views.getCompanyInsiderTrading),
    path('getStockPeers/',views.getStockPeers),
    path('getCompanyNameUsingTicker/',views.getCompanyNameUsingTicker),
    path('getCompanyKeyMetrics/',views.getCompanyKeyMetrics),
    path('activate/<uidb64>/<token>/', views.activate, name='activate'),
     path('activationSuccess/', views.activationSuccess, name='activationSuccess'),
     path('activationFail/', views.activationFail, name='activationFail'),
    
]