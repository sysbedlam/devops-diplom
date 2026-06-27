[servers]
srv ansible_host=${srv_ip} ansible_user=ubuntu

[k8s_master]
k8s-master ansible_host=${master_ip} ansible_user=ubuntu ansible_ssh_common_args='-o ProxyJump=ubuntu@${srv_ip}'

[k8s_nodes]
k8s-app ansible_host=${app_ip} ansible_user=ubuntu ansible_ssh_common_args='-o ProxyJump=ubuntu@${srv_ip}'

[k8s:children]
k8s_master
k8s_nodes
