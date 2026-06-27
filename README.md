# DevOps Diploma — Балашов Егор

Дипломная работа по курсу DevOps в SkillFactory. Полный цикл CI/CD: от инфраструктуры до мониторинга.

## Приложение

http://84.201.175.91

## Репозитории

- devops-diplom: https://github.com/sysbedlam/devops-diplom
- testapp: https://github.com/sysbedlam/testapp

## Стек

- Облако: Yandex Cloud
- IaC: Terraform
- Автоматизация: Ansible
- Контейнеризация: Docker
- Оркестрация: Kubernetes (kubeadm)
- Деплой: Helm
- CI/CD: GitHub Actions
- Мониторинг: Prometheus + Grafana + Blackbox Exporter
- Логи: Loki + Promtail
- Алертинг: Alertmanager

## Структура репозитория

    devops-diplom/
    terraform/    - Инфраструктура YC: 3 VM, сеть, NAT gateway
    ansible/      - Установка ПО на серверы
    helm/         - Helm чарт для Django приложения
    monitoring/   - docker-compose для стека мониторинга

## Быстрый старт

1. Terraform

    cd terraform
    yc iam key create --service-account-name terraform-sa --output sa-key.json
    terraform init
    terraform apply

2. Ansible

    cd ansible
    ansible-playbook playbook.yml

3. Kubernetes — выполняется вручную

    На k8s-master:
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.0.1.10
    kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

    На k8s-app:
    sudo kubeadm join 10.0.1.10:6443 --token <token> --discovery-token-ca-cert-hash <hash>

4. Helm деплой

    helm upgrade --install testapp ./helm/testapp --set image.tag=v1.0.7

5. Мониторинг

    Grafana: http://84.201.175.91:3000
    Логин: admin / admin

## Ручные шаги

- Инициализация k8s кластера (kubeadm init/join)
- Настройка kubeconfig на srv после инициализации
- Установка Promtail: helm install promtail grafana/promtail --set config.clients[0].url=http://10.0.1.20:3100/loki/api/v1/push
- Добавление datasources в Grafana (Prometheus, Loki)
- Импорт дашбордов: Node Exporter (1860), Blackbox Exporter (7587)
