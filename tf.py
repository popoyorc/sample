import pandas as pd
from time import sleep
from binance.client import Client
from binance.exceptions import BinanceAPIException

api_key = ''
api_secret = ''
symbol = 'BTCUSDT'

client = Client(api_key,api_secret)

def get_data(symbol):
    try:
        df = pd.DataFrame(client.get_historical_klines(symbol, '1m', '100m UTC'))
    except BinanceAPIException as e:
        print('sleeping...')
        sleep(60)
        df = pd.DataFrame(client.get_historical_klines(symbol, '1m', '100m UTC'))

    df = df.loc[:,[0,4]]
    df.columns = ['Time', 'Price']
    df.Time = pd.to_datetime(df.Time, unit = 'ms')
    df.Price = df.Price.astype(float)
    return df

#trend following strategy
def tf(symbol, qty, entry, lb=99, open_position = False):

    while True:
        df = get_data(symbol)
        lbp = df.iloc[-lb:]
        cumret = (lbp.Price.pct_change() +1).cumprod() - 1
        print(f'cr: {cumret[cumret.last_valid_index()]}', end='\r')
        if not open_position:
            if cumret[cumret.last_valid_index()] > entry:
                #print(f'Buying {qty} for {lbp.Price[lbp.last_valid_index()]}...')
                order = client.create_order(symbol=symbol,
                                            side='BUY',
                                            type='MARKET',
                                            quantity=qty)

                buyprice = float(order['fills'][0]['price'])
                print(f'\033[92mBUY\033[0m for {buyprice}')
                open_position = True
                break
    if open_position:
        while True:
            df = get_data(symbol)
            sb = df.loc[df.Time > pd.to_datetime(order['transactTime'], unit='ms')]
            if len(sb) > 1:
                sbr = (sb.Price.pct_change() +1).cumprod() - 1
                le = sbr[sbr.last_valid_index()]
                print(f'le: {le}', end='\r')
                if le > 0.0015 or le < -0.0015:
                    order = client.create_order(symbol=symbol,
                                                side='SELL',
                                                type='MARKET',
                                                quantity=qty)
                    #print(order)
                    sellprice = float(order['fills'][0]['price'])
                    commission = float(order['fills'][0]['commission'])*1000

                    profit = ((sellprice - buyprice)/buyprice)*commission
                    profit = ('\033[92m' if profit > 0 else '\033[91m') + str(round(profit,5)) + '\033[0m'
                    print(f'\033[91mSELL\033[0m for {sellprice} PROFIT : $ {profit}')
                    break

print(f'Trading {symbol}')
while True:                   
   tf(symbol, 0.0008, 0.0015, 60)
