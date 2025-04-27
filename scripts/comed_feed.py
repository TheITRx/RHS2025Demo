

import datetime
import requests as rq
import influxdb_client
import os
import time
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
import logging
logging.basicConfig(filename='/home/jocel/homelab/scripts/comed_feed.log',
                    encoding='utf-8', level=logging.DEBUG)
now = datetime.datetime.today().strftime("%d/%m/%Y %H:%M:%S")

push_url = "https://api.pushover.net/1/messages.json"
pushover_app_token = 'aycungp6nxojan7ikrcqzhvz5w97q7'
pushover_user_token = 'uf566zkv41227kzci2z5jy9ir9ujbm'
comed_api_url = 'https://hourlypricing.comed.com/api?type=5minutefeed'
token = 'zvh_Tms8DPRyEKBAkAA5QQKAWX5YLkqaJO8FrUgeR754er1GB9M-OxWEvTX_D8rR3ThCQJMwK3pLLRZlBWgFtA=='
org = "TheITRx"
url = "http://influxdb.theitrx.com"
push_headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
}

# set the threshold, notification is generated if it goes +-
cost_threshold = float(0)

# init influx client
write_client = influxdb_client.InfluxDBClient(url=url, token=token, org=org)
bucket = "bucket02"
measurement_name = 'comed_hourly_cost'
write_api = write_client.write_api(write_options=SYNCHRONOUS)

# gather Comed_info
req_result = rq.get(comed_api_url)
last_entry = req_result.json()[0]
cost_now = last_entry['price']

# 2nd to the last entry
last_entry2 = req_result.json()[1]
cost_now2 = last_entry2['price']

# convert comed time to epoch
time_epoch = datetime.datetime.fromtimestamp(
    (int(last_entry['millisUTC']))/1000)

# create row data
point = (
    Point(measurement_name)
    .field("cost", float(cost_now))
    .time(time_epoch)
)
# send to influxDB
write_api.write(bucket=bucket, org="TheITRx", record=point)

# send push notification if cost goes below zero
if float(cost_now) <= cost_threshold:

    if float(cost_now2) <= cost_threshold:
        logging.info(str(datetime.datetime.today()) + ': ' + 'No change. Cost still below zero.')

    else:
        push_message = f'Current cost as of {now} is {float(cost_now)}'
        push_title = 'ComEd Price Down Allert'
        push_payload = f'token={pushover_app_token}&user={pushover_user_token}&message={push_message}&priority=1&title={push_title}'

        response = rq.request(
            "POST", push_url, headers=push_headers, data=push_payload)

# if cost is above zero
else:
    if float(cost_now2) >= cost_threshold:
        logging.info(str(datetime.datetime.today()) + ': ' +
                     'No change. Cost still above zero.')
    else:
        push_message = f'Current cost as of {now} is {float(cost_now)}'
        push_title = 'ComEd Price Up Alert'
        push_payload = f'token={pushover_app_token}&user={pushover_user_token}&message={push_message}&priority=1&title={push_title}'

        response = rq.request(
            "POST", push_url, headers=push_headers, data=push_payload)

#logging.info(str(datetime.datetime.today()) + ': ' + str(point))
