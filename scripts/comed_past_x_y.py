import requests as rq
import influxdb_client
import datetime
import os
import time
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
import logging
logging.basicConfig(filename='comed_past.log',
                    encoding='utf-8', level=logging.DEBUG)

# token = os.environ.get("INFLUXDB_TOKEN")
req_url = 'https://hourlypricing.comed.com/api?type=5minutefeed'
req_url = 'https://hourlypricing.comed.com/api?type=5minutefeed&datestart=202301010000&dateend=202304161235'
token = 'zvh_Tms8DPRyEKBAkAA5QQKAWX5YLkqaJO8FrUgeR754er1GB9M-OxWEvTX_D8rR3ThCQJMwK3pLLRZlBWgFtA=='
org = "TheITRx"
url = "http://influxdb.theitrx.com"


write_client = influxdb_client.InfluxDBClient(url=url, token=token, org=org)
bucket = "bucket02"
measurement_name = 'comed_hourly_cost'
write_api = write_client.write_api(write_options=SYNCHRONOUS)



req_result = rq.get(req_url)
past_24 = req_result.json()


for entry in past_24:

    cost = entry['price']
    time_epoch = datetime.datetime.fromtimestamp(
        (int(entry['millisUTC']))/1000)
    point = (
        Point(measurement_name)
        .field("cost", float(cost))
        .time(time_epoch)
    )
    logging.info(point)
    write_api.write(bucket=bucket, org="TheITRx", record=point)
    #time.sleep(1)
