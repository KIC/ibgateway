Dockerized IB Gateway
===

Credits to https://github.com/ryanclouser/docker-ibgateway

```bash
docker build -t ibgateway .
docker run -d --rm --name ibgateway -e TRADING_MODE="p" -e ARGS="username=IB_USERNAME password=IB_PASSWORD" -p 5900:5900 -p 4002:4002 -v `pwd`/Jts:/home/ibg/Jts/ ibgateway
```

* make sure you start the conrainer inside this directory or do a manual setup via VNC-Viewer first
* Use the `TRADING_MODE` environment variable for **l**ive or **p**aper trading
* provide the correct username and password
* Use `USE_SSL` _true_|_false_ to enable (defeult) or disable ssl
* You can also pass the whole SSL string by using `SSL` variable like _ndc1.ibllc.com:4000,true,20000101,false;zdc1.ibllc.com:4000,true,20000101,false_
  By default current date is used to substitude the dates


