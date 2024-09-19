FROM p004mgmtaksacrea01.azurecr.io/ansible-operator:v1.34.0

USER root
RUN dnf update --security --bugfix -y && \
    dnf install -y openssl \
    dnf install -y vim

USER 1001

ARG DEFAULT_AWX_VERSION
ARG OPERATOR_VERSION
ENV DEFAULT_AWX_VERSION=${DEFAULT_AWX_VERSION}
ENV OPERATOR_VERSION=${OPERATOR_VERSION}

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/

ENTRYPOINT ["/tini", "--", "/usr/local/bin/ansible-operator", "run", \
    "--watches-file=./watches.yaml", \
    "--reconcile-period=0s" \
    ]
