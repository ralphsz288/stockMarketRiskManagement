from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.contrib import auth, messages
from django.http import HttpResponse
from django.middleware.csrf import get_token
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.contrib.sites.shortcuts import get_current_site
from django.template.loader import render_to_string
from django.core.mail import EmailMessage
from django.utils.encoding import force_bytes,force_str
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.conf import settings
from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import redirect
from django.contrib.auth import get_user_model
import requests
import json
import fmpsdk
import os
import numpy as np
import pandas as pd
import sys
import traceback
from dotenv import load_dotenv

load_dotenv()

apikey = os.getenv("API_KEY")

def getGrowthRate(rate):
    if(rate < 0):
        rate = rate * 2
    else:
        rate = rate / 2
    return rate


@api_view(['GET','POST'])
def getRoutes(request):
    routes=[
        {
            'Endpoint'  : '/calculator/',
            'method' : 'GET',
            'body' : None
        },
        {
            'Endpoint' : '/calculator/id/',
            'method' : 'GET',
            'body' : None
        }
    ]
    return Response(routes)


def activate(request, uidb64, token):
    try:
        uid = force_str(urlsafe_base64_decode(uidb64))
        user = get_user_model().objects.get(pk=uid)
        
        user.is_active = True
        user.save()
    
        return redirect('activationSuccess') 
        response = {
                "success": True,
        }
        return HttpResponse(json.dumps(response))
    except Exception as e:
        print(traceback.format_exc())
        return redirect('activationFail')
        response = {
                "success": False,
        }
        return HttpResponse(json.dumps(response))

def activationSuccess(request):
    return render(request, 'api/success.html')

def activationFail(request):
    return render(request,'api/fail.html')


def activateEmail(request, user, email):
    try:
        token = default_token_generator.make_token(user)
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        current_site = get_current_site(request)
        domain = current_site.domain
        subject = 'Activate your account'
        message = render_to_string("api/activation_email.html", {
            'user': user,
            'domain' : domain,
            'uid' : uid,
            'token' : token,
            "protocol" : 'https' if request.is_secure() else 'http'
        })
        email = EmailMessage(subject,message, to=[email])
        email.send()
    except Exception as e:
    
        print(traceback.format_exc())

@csrf_exempt
@require_http_methods(['POST'])
def register(request):
    username = request.POST['username']
    password = request.POST['password']
    email = request.POST['email']
    try:
        user = User.objects.create_user(
            username=username,password=password,email=email,is_active=False)
        user.save()
        
        activateEmail(request,user,email)
        
        response = {
            "success": True,
            "message": "Success",
        }
    except Exception as e:
        response = {
            "success": False,
            "message": "Success"
        }
        print(e)
    finally:
        return HttpResponse(json.dumps(response))

@csrf_exempt
@require_http_methods(['POST'])
def login(request):
    username = request.POST['username']
    password = request.POST['password']
    user = auth.authenticate(username=username, password=password)
    if user is not None:
        auth.login(request, user)
        response = {
            "success": True,
            "message": "Success",
            "token": get_token(request)
        }
    else: 
        response = {
            "success": False,
            "message": "Invalid credentials",
            "token": None
        }
    return HttpResponse(json.dumps(response))


@require_http_methods(['GET'])
def getPopularStocks(request):
    
    appleData = fmpsdk.quote(apikey = apikey , symbol = 'AAPL')
    applePrice = appleData[0]['price']
    applePriceDifference = appleData[0]['changesPercentage']

    googleData = fmpsdk.quote(apikey = apikey , symbol = 'GOOGL')
    googlePrice = googleData[0]['price']
    googlePriceDifference = googleData[0]['changesPercentage']

    amazonData = fmpsdk.quote(apikey = apikey , symbol = 'AMZN')
    amazonPrice = amazonData[0]['price']
    amazonPriceDifference = amazonData[0]['changesPercentage']

    intelData = fmpsdk.quote(apikey = apikey, symbol = 'INTC')
    intelPrice = intelData[0]['price']
    intelPriceDifference = intelData[0]['changesPercentage']

    response = {
        'succes' : True,
        'googlePrice' : googlePrice,
        'applePrice' : applePrice,
        'amazonPrice' : amazonPrice,
        'intelPrice' : intelPrice,
        'googlePriceDifference' : googlePriceDifference,
        'applePriceDifference' : applePriceDifference,
        'amazonPriceDifference' : amazonPriceDifference,
        'intelPriceDifference' : intelPriceDifference

    }

    return HttpResponse(json.dumps(response))


@require_http_methods(['GET'])
def getFreeCashFlow(request):
    companyTicker = request.GET['companyTicker'];
    growthAverage = request.GET['growthAverage'];
  
    cashFlowUrl = 'https://financialmodelingprep.com/api/v3/cash-flow-statement/{ticker}?apikey={}&limit=5'.format(apikey)
    enterPriseValuesUrl = 'https://financialmodelingprep.com/api/v3/enterprise-values/{ticker}?limit=1&apikey={}'.format(apikey)
    cashFlowGrowthUrl = 'https://financialmodelingprep.com/api/v3/cash-flow-statement-growth/{ticker}?limit=5&apikey={}'.format(apikey)
    companyProfileUrl = 'https://financialmodelingprep.com/api/v3/profile/{ticker}?apikey={}'.format(apikey)
   
    params = {'ticker': companyTicker}

    r = requests.get(cashFlowUrl.format(ticker=params['ticker']))
    data = json.loads(r.text)
    if(len(data) == 0):
        response = {
        'succes' : False,
        'message' : 'Ticker symbol is not correct. Please try again with a different one!'
        }
        return HttpResponse(json.dumps(response))
    elif (len(data) < 4):
        response = {
        'succes' : False,
        'message' : 'The company you selected does not have sufficient data to be analyzed further'
        }
        return HttpResponse(json.dumps(response))
    
    k = requests.get(enterPriseValuesUrl.format(ticker=params['ticker']))
    x = requests.get(cashFlowGrowthUrl.format(ticker=params['ticker']))

    growth = []
    if (growthAverage == '5year average free cash flow growth rate' or growthAverage == '5year average free cash flow growth rate/2' ):
        growthJson=json.loads(x.text)
        
        for i in range(0,len(growthJson)):
            growth.append(growthJson[i]['growthFreeCashFlow'])
        growthAvg = sum(growth) / len(growth)
        if (growthAverage == '5year average free cash flow growth rate/2'):
            growthAvg = getGrowthRate(growthAvg)
    else:
        try:
            growthAvg = float(growthAverage)
        except:
            response = {
                'succes' : False,
                'message' : 'The cash flow growth rate you entered is not a numerical value'
            }
            return HttpResponse(json.dumps(response))
    

    waccUrl = 'https://financialmodelingprep.com/api/v4/advanced_discounted_cash_flow?symbol={companyTicker}&apikey={}'.format(apikey)
    getWacc = requests.get(waccUrl.format(companyTicker=companyTicker.upper()))
    waccData = json.loads(getWacc.text)

    required_rate = waccData[0]['wacc']/100
    perpetual_rate = 0.03
    cashFlow_rate = growthAvg
    
    shares = json.loads(k.text)[0]['numberOfShares']

    list = []
    for i in range(0,len(data)):
        list.append(data[i]['freeCashFlow'])

    list.reverse()

    cashFlowValue = max(list[-1],list[-2],list[-3])
    terminalValue = cashFlowValue * (1+perpetual_rate)/(required_rate-perpetual_rate)

    futureCashFlows = []
    discountFactor = []
    discountedFutureFreeCashFlow = []

    for i in range(1,6):
        cashFlow = cashFlowValue * (1 + cashFlow_rate) ** i
        futureCashFlows.append(cashFlow)
        discountFactor.append((1+required_rate)**i)

    for i in range(0,len(discountFactor)):
        discountedFutureFreeCashFlow.append(futureCashFlows[i]/discountFactor[i])
    

    discounteTerminalValue = terminalValue/(1 + required_rate) ** 5
    discountedFutureFreeCashFlow.append(discounteTerminalValue)

    todaysValue = sum(discountedFutureFreeCashFlow)

    fairValue = todaysValue/shares

    profile = requests.get(companyProfileUrl.format(ticker=params['ticker']))
    profileData = json.loads(profile.text)
    
    response = {
        'succes' : True,
        'companyName' : profileData[0]['companyName'],
        'currentPrice' : profileData[0]['price'],
        'fairValue' : round(fairValue,1),
        'growthAverage' : round(growthAvg,2),
    }
    
    
    return HttpResponse(json.dumps(response))

@require_http_methods(['GET'])
def getStockNews(request):
    sources = ['CNBC Television','CNBC','Forbes','Yahoo Finance']
    try:
        companyTicker = request.GET['companyTicker']
        newsUrl = 'https://financialmodelingprep.com/api/v3/stock_news?tickers={ticker}&limit=500&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        news = requests.get(newsUrl.format(ticker=params['ticker']))
        data = json.loads(news.text)
        counter = 0
        returnList = []
        
        for i in range (0,len(data)):
            if(data[i]['site'] in sources):
                returnList.append(data[i])
                counter +=1
                if(counter == 3):
                    break
        if counter == 3:
            response = {
            'success' : True,
            'news1' : {
                'date' : returnList[0]['publishedDate'],
                'title' : returnList[0]['title'],
                'site' : returnList[0]['site'],
                'url' : returnList[0]['url'],
            },
            'news2' : {
                'date' : returnList[1]['publishedDate'],
                'title' : returnList[1]['title'],
                'site' : returnList[1]['site'],
                'url' : returnList[1]['url'],
            },
            'news3' : {
                'date' : returnList[2]['publishedDate'],
                'title' : returnList[2]['title'],
                'site' : returnList[2]['site'],
                'url' : returnList[2]['url'],
            },
            }
            return HttpResponse(json.dumps(response))


        if(len(data) < 3):
            response = {
                'succes' : False,
            }
            return HttpResponse(json.dumps(response))
    
        response = {
            'success' : True,
            'news1' : {
                'date' : data[0]['publishedDate'],
                'title' : data[0]['title'],
                'site' : data[0]['site'],
                'url' : data[0]['url'],
            },
            'news2' : {
                'date' : data[1]['publishedDate'],
                'title' : data[1]['title'],
                'site' : data[1]['site'],
                'url' : data[1]['url'],
            },
            'news3' : {
                'date' : data[2]['publishedDate'],
                'title' : data[2]['title'],
                'site' : data[2]['site'],
                'url' : data[2]['url'],
            },
        }
        

        return HttpResponse(json.dumps(response))
    except:
        response = {
                'succes' : False,
            }
        return HttpResponse(json.dumps(response))

    

@require_http_methods(['GET'])
def getStockPressRelease(request):
    try:
        companyTicker = request.GET['companyTicker'] 
        pressReleaseUrl = 'https://financialmodelingprep.com/api/v3/press-releases/{ticker}?page=0&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        pressRelease = requests.get(pressReleaseUrl.format(ticker=params['ticker']))
        pressReleaseData = json.loads(pressRelease.text)
    
        response = {
            'success' : True,
            'pressRelease1' : {
                'date' : pressReleaseData[0]['date'],
                'title' : pressReleaseData[0]['title'],
                'text' : pressReleaseData[0]['text'],
            },
            'pressRelease2' : {
                'date' : pressReleaseData[1]['date'],
                'title' : pressReleaseData[1]['title'],
                'text' : pressReleaseData[1]['text'],
            },
            'pressRelease3' : {
                'date' : pressReleaseData[2]['date'],
                'title' : pressReleaseData[2]['title'],
                'text' : pressReleaseData[2]['text'],
            },
        }
    except:
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))



@require_http_methods(['GET'])
def getAnalystEstimates(request):
    try:
        companyTicker = request.GET['companyTicker'] 
        analystEstimatesUrl = 'https://financialmodelingprep.com/api/v3/analyst-estimates/{ticker}?limit=1&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        analystEstimates = requests.get(analystEstimatesUrl.format(ticker=params['ticker']))
        analystEstimatesData = json.loads(analystEstimates.text)

        incomeStatementUrl = 'https://financialmodelingprep.com/api/v3/income-statement/{ticker}?limit=1&apikey={}'.format(apikey)
        incomeStatement = requests.get(incomeStatementUrl.format(ticker=params['ticker']))
        incomeStatementData = json.loads(incomeStatement.text)

        stockGradeUrl = 'https://financialmodelingprep.com/api/v3/grade/{ticker}?limit=5&apikey={}'.format(apikey)
        stockGrade = requests.get(stockGradeUrl.format(ticker=params['ticker']))
        stockGradeData = json.loads(stockGrade.text)

        response = {
            'success' : True,
            'date' : {
                'estimations' : analystEstimatesData[0]['date'],
                'report'      : incomeStatementData[0]['date']
            },
            'revenue' : {
                'estimated' : analystEstimatesData[0]['estimatedRevenueAvg'],
                'actual'    : incomeStatementData[0]['revenue']
            },
            'ebitda' : {
                'estimated' : analystEstimatesData[0]['estimatedEbitdaAvg'],
                'actual'    : incomeStatementData[0]['ebitda']
            },
            'netIncome' : {
                'estimated' : analystEstimatesData[0]['estimatedNetIncomeAvg'],
                'actual'    : incomeStatementData[0]['netIncome']
            },
            'eps' : {
                'estimated' : analystEstimatesData[0]['estimatedEpsAvg'],
                'actual'    : incomeStatementData[0]['eps']
            },
            'grade1' : {
                'newGrade' : stockGradeData[0]['newGrade'],
                'previousGrade' : stockGradeData[0]['previousGrade'],
                'gradingCompany' : stockGradeData[0]['gradingCompany'],
                'date' : stockGradeData[0]['date']
            },
            'grade2' : {
                'newGrade' : stockGradeData[1]['newGrade'],
                'previousGrade' : stockGradeData[1]['previousGrade'],
                'gradingCompany' : stockGradeData[1]['gradingCompany'],
                'date' : stockGradeData[1]['date']
            },
            'grade3' : {
                'newGrade' : stockGradeData[2]['newGrade'],
                'previousGrade' : stockGradeData[2]['previousGrade'],
                'gradingCompany' : stockGradeData[2]['gradingCompany'],
                'date' : stockGradeData[2]['date']
            },
            'grade4' : {
                'newGrade' : stockGradeData[3]['newGrade'],
                'previousGrade' : stockGradeData[3]['previousGrade'],
                'gradingCompany' : stockGradeData[3]['gradingCompany'],
                'date' : stockGradeData[3]['date']
            },
            'grade5' : {
                'newGrade' : stockGradeData[4]['newGrade'],
                'previousGrade' : stockGradeData[4]['previousGrade'],
                'gradingCompany' : stockGradeData[4]['gradingCompany'],
                'date' : stockGradeData[4]['date']
            },
        }
    except:
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))

@require_http_methods(['GET'])
def getStockNumberOfShares(request):
    try:
        companyTicker = request.GET['companyTicker'] 
        sharesOutUrl = 'https://financialmodelingprep.com/api/v3/enterprise-values/{ticker}?limit=5&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        sharesOut = requests.get(sharesOutUrl.format(ticker=params['ticker']))
        sharesOutData = json.loads(sharesOut.text )
        percentage = sharesOutData[0]['numberOfShares']/sharesOutData[4]['numberOfShares'] * 100
        percentage = 100 - percentage
        percentage = round(percentage,2)
        response = {
            'success' : True,
            'data' :[
                {'numberOfShares' : sharesOutData[0]['numberOfShares'],'date' : sharesOutData[0]['date'] },
                {'numberOfShares' : sharesOutData[1]['numberOfShares'],'date' : sharesOutData[1]['date'] },
                {'numberOfShares' : sharesOutData[2]['numberOfShares'],'date' : sharesOutData[2]['date'] },
                {'numberOfShares' : sharesOutData[3]['numberOfShares'],'date' : sharesOutData[3]['date'] },
                {'numberOfShares' : sharesOutData[4]['numberOfShares'],'date' : sharesOutData[4]['date'] },
            ],
            'percentage' : percentage,
            }
    except Exception as e:
        print(e)
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))

@require_http_methods(['GET'])
def getValueAtRiskAndVolatilty(request):
    alpha = 0.95
    try:
        companyTicker = request.GET['companyTicker'] 
        changeOverTimeUrl = 'https://financialmodelingprep.com/api/v3/historical-price-full/{ticker}?from=2007-03-12&to=today&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        changeOverTime = requests.get(changeOverTimeUrl.format(ticker=params['ticker']))
        changeOverTimeData = json.loads(changeOverTime.text)
        changeOverTimeItems = list(changeOverTimeData.items())
        stockData = changeOverTimeItems[1][1]        
        firstDay = stockData[-1]['date']
        changeOverTime = [item['changeOverTime'] for item in stockData]
        closeOverTime = [item['close'] for item in stockData]

        dff = pd.DataFrame(changeOverTime,columns=['Price'])
        vol = dff['Price'].std()
        anualized_vol = vol * np.sqrt(252) * 100
        average_return = np.mean(dff)
                
        df = pd.DataFrame(closeOverTime, columns=['Price'])
        df['Returns'] = df['Price'].pct_change()
        volatility = df['Returns'].std()
        anualized_volatility = volatility * np.sqrt(252) * 100

        min_index = changeOverTime.index(min(changeOverTime))
        max_index = changeOverTime.index(max(changeOverTime))
        min_date = stockData[min_index]['date']
        max_date = stockData[max_index]['date']
     
        stockData.reverse()
        prices = [item['close'] for item in stockData]
        s = pd.DataFrame(prices, columns=['Price'])
        s['returns'] = s['Price'].pct_change().dropna()
        rate = 0.02/252
        s['excess'] = s['returns'] - rate
        sharpe = np.sqrt(252) * (s['returns'].mean() - rate) / s['excess'].std()

        downside_returns = s['returns'][s['returns'] < 0]
        average_downside_return = s['returns'].mean()
        sortino_ratio = (average_downside_return - rate) / (downside_returns.std() * np.sqrt(252))


        var = np.percentile(changeOverTime, 1-alpha)*100
        var2 = np.quantile(changeOverTime,1-alpha)*100


        sp500ChangeOverTimeUrl = 'https://financialmodelingprep.com/api/v3/historical-price-full/^GSPC?from=2007-03-12&to=today&apikey={}'.format(apikey)
        sp500ChangeOverTime = requests.get(sp500ChangeOverTimeUrl)
        sp500Data = json.loads(sp500ChangeOverTime.text)
        sp500Items = list(sp500Data.items())
        sp500 = sp500Items[1][1]
        sp500.reverse()
        sp500ChangeOverTime = [item['close'] for item in sp500]
        sp500Df = pd.DataFrame(sp500ChangeOverTime,columns = ['Adj Close'])
        np.set_printoptions(threshold=sys.maxsize)
        s['returns'] = s['returns'].dropna()
        market_returns = sp500Df['Adj Close'].pct_change()
        market_returns = market_returns.dropna()

        nan_mask = np.isnan(s['returns'].dropna())

        s['returns'] = s['returns'].replace([np.inf, -np.inf], np.nan).dropna()
        market_returns = market_returns.replace([np.inf, -np.inf], np.nan).dropna()
        s, market_returns = s.align(market_returns, join='inner',axis=0)
       
        covariance = np.cov(s['returns'], market_returns, ddof=0)[0, 1]
        market_variance = np.var(market_returns, ddof=0)
        beta = covariance / market_variance

        response = {
            'success' : True,
            'data' : var,
            'data2' : round(var2,2),
            'maxChange' : {
                'value' : round(max(changeOverTime)*100,2),
                'date'  : min_date
            },
            'minChange' : {
                'value' : round(min(changeOverTime)*100,2),
                'date'  : max_date
            },
            'vol' : round(anualized_vol,2),
            'sharpe' : round(sharpe,2),
            'sortino' : round(sortino_ratio * 100 , 2),
            'firstDay' : firstDay,
            'beta'  : round(beta,2),
        }
    except Exception as e:
        response = {'success' : False}
        print(e)
    
    return HttpResponse(json.dumps(response))

@require_http_methods(['GET'])
def getCompanyInsiderTrading(request):
    try:
        companyTicker = request.GET['companyTicker'] 
        insiderTradingUrl = 'https://financialmodelingprep.com/api/v4/insider-trading?symbol={ticker}&page=0&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        insiderTrading = requests.get(insiderTradingUrl.format(ticker=params['ticker']))
        insiderTradingData = json.loads(insiderTrading.text )
        response = {
            'success' : True,
            'data' : [
                {
                    'date' : insiderTradingData[0]['transactionDate'],
                    'type' : insiderTradingData[0]['transactionType'],
                    'name' : insiderTradingData[0]['reportingName'],
                    'position' : insiderTradingData[0]['typeOfOwner'],
                    'acquisitionOrDisposition' : insiderTradingData[0]['acquistionOrDisposition'],
                    'securitiesTransacted' : insiderTradingData[0]['securitiesTransacted'],
                    'price' : str(insiderTradingData[0]['price']),
                    'securityName' : insiderTradingData[0]['securityName'],
                    'link' : insiderTradingData[0]['link']
                },
                {
                    'date' : insiderTradingData[1]['transactionDate'],
                    'type' : insiderTradingData[1]['transactionType'],
                    'name' : insiderTradingData[1]['reportingName'],
                    'position' : insiderTradingData[1]['typeOfOwner'],
                    'acquisitionOrDisposition' : insiderTradingData[1]['acquistionOrDisposition'],
                    'securitiesTransacted' : insiderTradingData[1]['securitiesTransacted'],
                    'price' : str(insiderTradingData[1]['price']),
                    'securityName' : insiderTradingData[1]['securityName'],
                    'link' : insiderTradingData[1]['link']
                },
                {
                    'date' : insiderTradingData[2]['transactionDate'],
                    'type' : insiderTradingData[2]['transactionType'],
                    'name' : insiderTradingData[2]['reportingName'],
                    'position' : insiderTradingData[2]['typeOfOwner'],
                    'acquisitionOrDisposition' : insiderTradingData[2]['acquistionOrDisposition'],
                    'securitiesTransacted' : insiderTradingData[2]['securitiesTransacted'],
                    'price' : str(insiderTradingData[2]['price']),
                    'securityName' : insiderTradingData[2]['securityName'],
                    'link' : insiderTradingData[2]['link']
                },
                {
                    'date' : insiderTradingData[3]['transactionDate'],
                    'type' : insiderTradingData[3]['transactionType'],
                    'name' : insiderTradingData[3]['reportingName'],
                    'position' : insiderTradingData[3]['typeOfOwner'],
                    'acquisitionOrDisposition' : insiderTradingData[3]['acquistionOrDisposition'],
                    'securitiesTransacted' : insiderTradingData[3]['securitiesTransacted'],
                    'price' : str(insiderTradingData[3]['price']),
                    'securityName' : insiderTradingData[3]['securityName'],
                    'link' : insiderTradingData[3]['link'] 
                },
                {
                    'date' : insiderTradingData[4]['transactionDate'],
                    'type' : insiderTradingData[4]['transactionType'],
                    'name' : insiderTradingData[4]['reportingName'],
                    'position' : insiderTradingData[4]['typeOfOwner'],
                    'acquisitionOrDisposition' : insiderTradingData[4]['acquistionOrDisposition'],
                    'securitiesTransacted' : insiderTradingData[4]['securitiesTransacted'],
                    'price' : str(insiderTradingData[4]['price']),
                    'securityName' : insiderTradingData[4]['securityName'],
                    'link' : insiderTradingData[4]['link']
                },
            ],
        }
    except Exception as e:
        print(e)
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))


@require_http_methods(['GET'])
def getStockPeers(request):
    try:
        companyTicker = request.GET['companyTicker']
        companyProfileUrl = 'https://financialmodelingprep.com/api/v3/profile/{profileTicker}?apikey={}'.format(apikey)
        stockPeersUrl = 'https://financialmodelingprep.com/api/v4/stock_peers?symbol={ticker}&apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        stockPeers = requests.get(stockPeersUrl.format(ticker=params['ticker']))
        stockPeersData = json.loads(stockPeers.text)

        mainStockProfile = requests.get(companyProfileUrl.format(profileTicker=params['ticker']))
        mainStockProfileData = json.loads(mainStockProfile.text)
        mainCompanyList = []

        companies=[]
        for i in stockPeersData[0]['peersList']:
            profileParams = {'profileTicker' : i}
            companyProfile = requests.get(companyProfileUrl.format(profileTicker=profileParams['profileTicker']))
            companyProfileData = json.loads(companyProfile.text)
            if companyProfileData[0]['companyName']:
                if companyProfileData[0]['mktCap'] > 0 and (mainStockProfileData[0]['mktCap'] / companyProfileData[0]['mktCap'] and companyProfileData[0]['companyName'] != mainStockProfileData[0]['companyName']) < 10000 :
                    info = {
                        'name' : companyProfileData[0]['companyName'],
                        'ticker' : i,
                        'marketCap' : companyProfileData[0]['mktCap'],
                        'price' : round(companyProfileData[0]['price'],2),
                        'volAvg' : companyProfileData[0]['volAvg'],
                        'range' : companyProfileData[0]['range'],
                        'sector' : companyProfileData[0]['sector']
                    }
                    companies.append(info)
        response = {
            'success' : True,
            'data' : companies,
            'mainCompany' : {
                'name' : mainStockProfileData[0]['companyName'],
                'ticker' : params['ticker'],
                'mktCap' : mainStockProfileData[0]['mktCap'],
                'price' : round(mainStockProfileData[0]['price'],2),
                'volAvg' : mainStockProfileData[0]['volAvg'],
                'range' : mainStockProfileData[0]['range'],
                'sector' : mainStockProfileData[0]['sector']
            },
        }
    except Exception as e:
        print(e)
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))


@require_http_methods(['GET'])
def getCompanyNameUsingTicker(request):
    try:
        companyTicker = request.GET['companyTicker']
        companyProfileUrl = 'https://financialmodelingprep.com/api/v3/profile/{profileTicker}?apikey={}'.format(apikey)
        params = {'ticker': companyTicker}
        mainStockProfile = requests.get(companyProfileUrl.format(profileTicker=params['ticker']))
        mainStockProfileData = json.loads(mainStockProfile.text)
        response = {
            'success' : True,
            'name' : mainStockProfileData[0]['companyName'],
            'mktCap' : mainStockProfileData[0]['mktCap'],
            'price' : round(mainStockProfileData[0]['price'],2),
            'volAvg' : mainStockProfileData[0]['volAvg'],
            'range' : mainStockProfileData[0]['range'],
            'sector' : mainStockProfileData[0]['sector']
        }
    except Exception as e:
        print(e)
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))

    
@require_http_methods(['GET'])
def getCompanyKeyMetrics(request):
    try:
        companyTicker = request.GET['companyTicker']
        balanceSheetUrl = 'https://financialmodelingprep.com/api/v3/balance-sheet-statement/{profileTicker}?limit=1&apikey={}'.format(apikey)
        incomeStatementUrl = 'https://financialmodelingprep.com/api/v3/income-statement/{profileTicker}?limit=1&apikey={}'.format(apikey)
        ratiosUrl = 'https://financialmodelingprep.com/api/v3/ratios-ttm/{profileTicker}?apikey={}'.format(apikey)
        params = {'ticker': companyTicker}

        balanceSheet = requests.get(balanceSheetUrl.format(profileTicker=params['ticker']))
        balanceSheetData = json.loads(balanceSheet.text)

        incomeStatement = requests.get(incomeStatementUrl.format(profileTicker=params['ticker']))
        incomeStatementData = json.loads(incomeStatement.text)

        ratios = requests.get(ratiosUrl.format(profileTicker=params['ticker']))
        ratiosData = json.loads(ratios.text)

        response = {
            'success' : True,
            'eps' : incomeStatementData[0]['eps'],
            'netIncome' : incomeStatementData[0]['netIncome'],
            'revenue' : incomeStatementData[0]['revenue'],
            'grossProfitRatio' : round(incomeStatementData[0]['grossProfitRatio'],2),
            'peRatio' : round(ratiosData[0]['peRatioTTM'],2),
            'dividend' : ratiosData[0]['dividendPerShareTTM'],
            
        }
    except Exception as e:
        print(e)
        response = {'success' : False}
    
    return HttpResponse(json.dumps(response))

