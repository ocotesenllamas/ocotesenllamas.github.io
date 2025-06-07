FROM ubuntu:22.04

ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV RBENV_ROOT=/home/${USERNAME}/.rbenv
ENV PATH=${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH
ENV RUBY_VERSION=3.4.4

ENV TZ="America/Monterrey"
RUN apt-get update 
RUN apt-get install -y tzdata
# Crear usuario y grupo
RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
 # Instalar sudo y dar permisos
 && apt-get install -y sudo  git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev \
    libgdbm6 libgdbm-dev libdb-dev apt-utils \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME} \
 && apt-get upgrade -y \
 && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Instalar rbenv y ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
 && git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build

# Inicializar rbenv para shell y instalar Ruby
RUN echo 'export PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH"' >> ~/.bashrc \
 && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Ejecutar instalación de ruby en un hell que cargsa rbenv
RUN /bin/bash -c "source ~/.bashrc && rbenv install ${RUBY_VERSION} && rbenv global ${RUBY_VERSION} && rbenv rehash"

# Instalar jekyll
RUN /bin/bash -c "source ~/.bashrc && gem install jekyll && rbenv rehash"

CMD [ "bash" ]
