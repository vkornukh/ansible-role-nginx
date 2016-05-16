FROM ubuntu:14.04.3
MAINTAINER drue@spscommerce.com
RUN apt-get update
RUN apt-get install -y python-dev python-pip vim
RUN pip install paramiko==1.16.0 ansible==1.9.4 httplib2

ADD ./tests /tmp/playbook
ADD . /tmp/playbook/roles/ansible-role-nginx
WORKDIR /tmp/playbook
ENV ANSIBLE_FORCE_COLOR=true
ENV PYTHONUNBUFFERED=1

## run tests
RUN ansible-playbook -vvvv -i "[test] localhost," -c local tests.yml -e "environ=dev" &&\
    ansible-playbook -i "[test] localhost," -c local tests.yml -e "environ=dev" 2>/dev/null | grep -q 'changed=0.*failed=0' &&\
    (echo 'Idempotence test: \033[0;32mpass\033[0m' && exit 0) ||\
    (echo 'Idempotence test: \033[0;31mfail\033[0m' && exit 1)

CMD /bin/bash
