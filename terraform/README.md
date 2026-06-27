# Terraform — инфраструктура Yandex Cloud

## Что создаётся

- VPC сеть и подсеть `10.0.1.0/24`
- `k8s-master` — мастер нода Kubernetes (10.0.1.10, без внешнего IP)
- `k8s-app` — воркер нода Kubernetes (10.0.1.11, без внешнего IP)
- `srv` — сервер мониторинга и сборок (10.0.1.20, внешний IP)

## Требования

- Terraform >= 1.0
- Yandex Cloud CLI (`yc`)
- Сервисный аккаунт YC с ролью `editor`

## Развёртка

1. Клонировать репозиторий:
```bash
   git clone https://github.com/sysbedlam/devops-diplom.git
   cd devops-diplom/terraform
```

2. Создать сервисный аккаунт и ключ:
```bash
   yc iam service-account create --name terraform-sa
   yc resource-manager folder add-access-binding <folder_id> \
     --role editor \
     --subject serviceAccount:<sa_id>
   yc iam key create --service-account-name terraform-sa --output sa-key.json
```

3. Инициализировать Terraform:
```bash
   terraform init
```

4. Применить конфигурацию:
```bash
   terraform apply
```

## Секреты

`sa-key.json` — не коммитить, добавлен в `.gitignore`.
