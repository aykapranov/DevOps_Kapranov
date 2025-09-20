# Задание 1. Volume: обмен данными между контейнерами в поде

[containers-data-exchange.yaml](01%2Fcontainers-data-exchange.yaml)

![img_1.png](01%2Fimg_1.png)
![img.png](01/img.png)


# Задание 2. PV, PVC

[pv-pvc.yaml ](02%2Fpv-pvc.yaml%20)

![img.png](02%2Fimg.png)
![img.png](img.png)
![img_1.png](02%2Fimg_1.png)


PV остаётся в состоянии Released, он отвязан, но не удалён.

![img_1.png](img_1.png)


Файл остался после удаления PVC
![img_2.png](img_2.png)

Удаляем PV

![img_3.png](img_3.png)

В yaml файле указано `persistentVolumeReclaimPolicy: Retain`, поэтому данные остались.
![img_4.png](img_4.png)


# Задание 3. StorageClass


![img_5.png](img_5.png)


![img_6.png](img_6.png)