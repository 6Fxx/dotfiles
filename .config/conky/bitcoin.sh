#!/bin/bash

# Cours du Bitcoin
#bitcoin=$(curl -s --max-time 10 'https://api.coindesk.com/v1/bpi/currentprice/EUR.json' | grep -oP '(?<="United States Dollar","rate_float":).*?(?=\})' | sed 's/\./,/')
curl -s --max-time 10 'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD' | grep -oP '(?<="USD":).*?(?=\})' | sed 's/\./,/'
echo $bitcoin
# Cours de l'Ethereum
#curl -s --max-time 10 'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD' | grep -oP '(?<="USD":).*?(?=\})' | sed 's/\./,/'
