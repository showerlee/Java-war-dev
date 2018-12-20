# Showerlee ansible playbooks

Simple Ansible playbooks integrated with Jenkins and Gitlab for Jenkins Continuous deployment

## How to use

``` shell
ansible-playbook -i inventory/[qa/prod] ./deploy.yml -e project=[wordpress/phpcms] -e branch=[master/develop] -e env=[qa/prod]
```
