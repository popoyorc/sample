from binance import Client
from binance.exceptions import BinanceAPIException
import argparse
import pandas as pd
import ta
import numpy as np
import time
import sys

api_key = ''
api_secret = ''


client = Client(api_key, api_secret)


ap = argparse.ArgumentParser()

# Add the arguments to the parser
ap.add_argument("-s", "--symbol", required=True, help="first operand")
ap.add_argument("-q", "--qty", required=True, help="second operand")
args = vars(ap.parse_args())
symbol = args['symbol']
qty = float(args['qty'])

def gmd(symbol, interval, lookback):

    try:
    	frame = pd.DataFrame(client.get_historical_klines(symbol,
                                                     interval,
                                                     lookback + ' min ago UTC'))
    except BinanceAPIException as e:
    	print(f'sleeping..')
    	time.sleep(60)
    	frame = pd.DataFrame(client.get_historical_klines(symbol,
                                                     interval,
                                                     lookback + ' min ago UTC'))
    frame = frame.iloc[:,:6]
    frame.columns = ['Time', 'Open', 'High', 'Low', 'Close', 'Volume']
    frame = frame.set_index('Time')
    frame.index = pd.to_datetime(frame.index, unit='ms')
    frame = frame.astype(float)
    return frame

def at(df):
    df['%K'] = ta.momentum.stoch(df.High,df.Low,df.Close, window=14,
                                smooth_window=3)
    df['%D'] = df['%K'].rolling(3).mean()
    df['rsi'] = ta.momentum.rsi(df.Close, window=14)
    df['macd'] = ta.trend.macd_diff(df.Close)
    df.dropna(inplace=True) 
    
class Signals:
    
    def __init__(self, df, lags):
        self.df = df
        self.lags = lags
        
    def gt(self):
        dfx = pd.DataFrame()
        for i in range(self.lags + 1):
            mask = (self.df['%K'].shift(i) < 20) & (self.df['%D'].shift(i) < 20)
            dfx = dfx.append(mask, ignore_index=True)
        return dfx.sum(axis=0)
    
    def d(self):
        self.df['trigger'] = np.where(self.gt(), 1, 0)
        self.df['Buy'] = np.where((self.df.trigger) &
                                 (self.df['%K'].between(20, 80)) &
                                 (self.df['%D'].between(20, 80)) &
                                 (self.df.rsi > 50) &
                                 (self.df.macd > 0), 1, 0)
                                 
def strategy(pair, qty, open_position=False):
    df = gmd(pair, '1m', '100')
    at(df)
    inst = Signals(df, 5)
    inst.d()
    print(f'{pair}: ' + str(df.Close.iloc[-1]), end='\r')
    
    if df.Buy.iloc[-1]:
        print(f'{pair}: ' + str(df.Close.iloc[-1]))
        qty = round(qty/df.Close.iloc[-1],4)
        order = client.create_order(symbol=pair,
                                   side='BUY',
                                   type='MARKET',
                                   quantity=qty)
        buyprice = float(order['fills'][0]['price'])
        print(f'\033[92mBUY\033[0m for {buyprice}')
        open_position = True
        
    while open_position:
        time.sleep(0.5)
        df = gmd(pair, '1m', '2')
        print(f'CLS: ' + str(df.Close.iloc[-1]) + 
              ' TRGT: ' + str(round(buyprice * 1.005,2)) + 
              ' STP: ' + str(round(buyprice * 0.995,2)), end='\r')
        if df.Close[-1] <= buyprice * 0.995 or df.Close[-1] >= 1.005 * buyprice:
            print(f'CLS: ' + str(df.Close.iloc[-1]) + 
              ' TRGT: ' + str(round(buyprice * 1.005,2)) + 
              ' STP: ' + str(round(buyprice * 0.995,2)))
            order = client.create_order(symbol=pair,
                           side='SELL',
                           type='MARKET',
                           quantity=qty) 
            sellprice = float(order['fills'][0]['price'])
            commission = float(order['fills'][0]['commission'])*1000
            
            #profit = ((sellprice - buyprice)/buyprice)*commission
            profit = (sellprice*float(qty))-(buyprice*float(qty))
            profit = ('\033[92m' if profit > 0 else '\033[91m') + str(round(profit,5)) + '\033[0m'
            print(f'\033[91mSELL\033[0m for {sellprice} PROFIT : $ {profit}')
            break
            
            
print(f'Trading {symbol}')
while True:
    strategy(symbol, qty)
    time.sleep(0.5)
