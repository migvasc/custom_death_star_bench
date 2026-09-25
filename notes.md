# Notes for running DeathStarBenchmark - hotel reservation into Grid5k (v 0.1)

Instructions:
 Clone this git repository
```
git clone  git@gitlab.irit.fr:sepia/coop/e2cc/configureddeathstarbenchmark
```

Install and configure kubernetes on G5K, here is the tutorial: https://www.grid5000.fr/w/User:Apetit/kubernetes-cluster

Required steps: install kubectl and helm charts; I used the tutorial with the custom debian image (debian11-k8s).

Optional plugins: istio (network monitoring); alumet (resource monitoring)

###  istio 

Instructions : https://istio.io/latest/docs/setup/getting-started/

Important: install kialli (dashboard for visualization) and prometheus (for exporting the data)


### alumet
Commands:
```
helm repo add influxdata https://helm.influxdata.com/
helm repo add alumet https://alumet-dev.github.io/helm-charts/
```

If you want to use the csv export:

```
helm install test-alumet alumet/alumet  --set alumet-relay-client.plugins.csv.enable="true"  --set alumet-relay-server.plugins.csv.enable="true" --set influxdb2.persistence.enabled="false" --set  alumet-relay-server.plugins.prometheusExporter.enable="false" --set alumet-relay-client.plugins.prometheusExporter.enable="false" --set alumet-relay-client.plugins.rapl.enable="true" --set alumet-relay-client.plugins.rapl.poll_interval="1s" --set alumet-relay-client.plugins.k8s.poll_interval="1s"
```
If you want to use influx db, it is required to configure storage in the node, I used the configuration from: https://github.com/rancher/local-path-provisioner
```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.36/deploy/local-path-storage.yaml
kubectl patch storageclass local-path  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
helm install test-alumet alumet/alumet  --set  alumet-relay-server.plugins.prometheusExporter.enable="false" --set alumet-relay-client.plugins.prometheusExporter.enable="false" --set alumet-relay-client.plugins.rapl.enable="true" --set alumet-relay-client.plugins.rapl.poll_interval="1s" --set alumet-relay-client.plugins.k8s.poll_interval="1s"   
```

To allow connecting to the influxdb service, run:
```
kubectl patch svc test-alumet-influxdb2 -n default -p '{"spec":{"type":"NodePort"}}'
```
To get the secret for influx db run :
```
kubectl get secret test-alumet-influxdb2-auth -o jsonpath="{.data.admin-password}" | base64 -d && echo ''
```

### Deploying the application

After the configuration is done (kubernetes and all plugins), to deploy the deathstarbenchmark, run:
```
kubectl apply -Rf DeathStarBench/hotelReservation/kubernetes/
````

Then, execute :
```
watch -n 1 "kubectl get pods"
```

And wait until all the pods get to the status "Running" 

For acessing the microservices outside grid5k, and sending requests, execute:

```
kubectl patch svc frontend -n default -p '{"spec":{"type":"NodePort"}}'
```

To discover which port was configured, run the command to get details of the service

Ex:
```
kubectl get svc frontend
NAME       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
frontend   NodePort   10.108.120.28   <none>        5000:30960/TCP   20m
```

To discover the nodes names:
```
kubectl get nodes
NAME                         STATUS   ROLES           AGE   VERSION
taurus-10.lyon.grid5000.fr   Ready    control-plane   27m   v1.33.4
taurus-9.lyon.grid5000.fr    Ready    <none>          24m   v1.33.4
```

In this example, the worker node is taurus-9.lyon.grid5000.fr


## Sending requests 

In a separate node, install wrk to send the requests.

Required:

luajit: https://luajit.org/download.html

Command: 
```
sudo-g5k && sudo apt-get install -y lua5.1 liblua5.1 liblua5.1-dev luarocks docker-compose gawk && sudo luarocks install luasocket && cd luajit && sudo make install && export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH 
cd DeathStarBench/wrk2/ && make 
```

The file req_sender.sh is an example of how to use wrk to send requests. This script runs the requests in 4 different load scenarios over 5 minutes: 1 req/s, 10 req/s, 100 req/s, and 1000 req/s.

Example of usage: need to pass the address and port of the frontend service, and the path to the request script.

```
bash req_sender.sh http://taurus-4.lyon.grid5000.fr:31059 hotelReservation/wrk2/scripts/hotel-reservation/search_hotel.lua
```

### Acessing prometheus, jaeger, kiali dash board

Need to configure the services, as done with the frontend:
```
kubectl patch svc jaeger -n default -p '{"spec":{"type":"NodePort"}}'
kubectl patch svc prometheus -n istio-system -p '{"spec":{"type":"NodePort"}}'
```
To get information about the configured port:
```
kubectl get svc jaeger
kubectl get svc svc prometheus -n istio-system
```
Then, on your local machine, you need to create the ssh tunnel, for example, if the port of jaeger was 31453 and the worker node was taurus-15:
```
ssh -J user@lyon.g5k  -l root user@taurus-15.lyon.grid5000.fr  -L31453:localhost:31453
```

### Example of prometheus queries

Avg. request size between microservices (last 30 min):
```
sum(increase(istio_request_bytes_sum{
  reporter="source",
  source_workload!="unknown",
  destination_workload!="unknown",source_workload!="consul",
  destination_workload!="consul"
}[30m])) by (source_workload, destination_workload)

/

sum(increase(istio_request_bytes_count{
  reporter="source",
  source_workload!="unknown",
  destination_workload!="unknown",
  source_workload!="consul",
  destination_workload!="consul",
}[30m])) by (source_workload, destination_workload)
```

Avg. response size between microservices (last 30 min)
```
sum(increase(istio_response_bytes_sum{
  reporter="source",
  source_workload!="unknown",
  destination_workload!="unknown",
  source_workload!="consul",
  destination_workload!="consul"
}[30m])) by (source_workload, destination_workload)

/

sum(increase(istio_response_bytes_count{
  reporter="source",
  source_workload!="unknown",
  destination_workload!="unknown",
  source_workload!="consul",
  destination_workload!="consul"
}[30m])) by (source_workload, destination_workload)

```