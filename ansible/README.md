# Ansible — автоматизация настройки серверов

## Что делает плейбук

### srv
- Устанавливает Docker CE + docker-compose-plugin
- Включает IP forwarding
- Настраивает iptables MASQUERADE для NAT
- Добавляет пользователя ubuntu в группу docker

### k8s-master, k8s-app
- Отключает swap (требование Kubernetes)
- Загружает модули ядра: overlay, br_netfilter
- Настраивает sysctl параметры для работы сети k8s
- Устанавливает containerd как container runtime
- Устанавливает kubeadm, kubelet, kubectl v1.29
- Фиксирует версии kubernetes пакетов (hold)

## Что сделано вне Ansible

- SSH ключи — передаются через Terraform metadata при создании VM
- CI/CD runner — используется GitHub Actions, установка на сервер не требуется

## Запуск

    sudo apt install ansible -y
    ansible all -m ping
    ansible-playbook playbook.yml

## Структура

    ansible/
    ansible.cfg       - конфигурация ansible
    inventory.ini     - генерируется автоматически через Terraform
    playbook.yml      - основной плейбук
    README.md

## Примечание

inventory.ini генерируется автоматически при terraform apply из шаблона terraform/inventory.tpl.
При пересоздании VM достаточно запустить terraform apply — inventory обновится сам.
