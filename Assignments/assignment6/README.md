## Ansible Training
Used a dedicated AWS instance to run instance playbooks.

- __vpc.yml:__ To create a new VPC with a single public subnet in AWS 
- __keypair.yml__:  To create a new key in AWS keypair
- __instance.yml__:  To create a new instance (ubuntu) in your new VPC, and installing Docker
- __nginx.yml__:  To run an NGINX docker container on the instance using Ansible

To run each file use:

```sh
ansible-playbook name.yml
```
Before running nginx you need to add the new instance to your Ansible inventory on /etc/ansible/hosts

