FROM ruby:3.4.4-slim

ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV TZ="America/Monterrey"
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    tzdata \
    git \
    curl \
    build-essential \
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    sudo \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && chmod -R 755 /usr/local/lib/ruby/gems \
    && chmod -R 755 /usr/local/bundle

# Crear usuario y grupo
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && usermod -aG staff ${USERNAME}

# Cambiar a usuario no-root
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Crear directorios para volúmenes persistentes
RUN mkdir -p /home/${USERNAME}/.bash_history_dir \
    && mkdir -p /home/${USERNAME}/.gem \
    && mkdir -p /home/${USERNAME}/workspace

# Configurar permisos y paths para gems
RUN echo 'export GEM_HOME="$HOME/.gem"' >> ~/.bashrc \
    && echo 'export GEM_PATH="$HOME/.gem"' >> ~/.bashrc \
    && echo 'export PATH="$HOME/.gem/bin:$PATH"' >> ~/.bashrc \
    && echo 'export BUNDLE_USER_HOME="$HOME"' >> ~/.bashrc \
    && echo 'export BUNDLE_USER_CACHE="$HOME/.bundle"' >> ~/.bashrc \
    && echo 'export BUNDLE_USER_CONFIG="$HOME/.bundle/config"' >> ~/.bashrc \
    && echo 'export BUNDLE_USER_PLUGIN="$HOME/.bundle/plugin"' >> ~/.bashrc

# Configurar bash history persistente
RUN echo 'export HISTFILE=/home/${USERNAME}/.bash_history_dir/.bash_history' >> ~/.bashrc \
    && echo 'export HISTSIZE=10000' >> ~/.bashrc \
    && echo 'export HISTFILESIZE=20000' >> ~/.bashrc \
    && echo 'export HISTCONTROL=ignoredups:erasedups' >> ~/.bashrc \
    && echo 'shopt -s histappend' >> ~/.bashrc

# Configurar gem environment y instalar bundler y jekyll
RUN export GEM_HOME="$HOME/.gem" \
    && export GEM_PATH="$HOME/.gem" \
    && export PATH="$HOME/.gem/bin:$PATH" \
    && mkdir -p "$HOME/.gem" "$HOME/.bundle" \
    && gem install bundler jekyll \
    && bundle config set --global path "$HOME/.bundle" \
    && bundle config set --global bin "$HOME/.bundle/bin" \
    && bundle config set --global user_home "$HOME"

# Configurar directorio de trabajo
WORKDIR /home/${USERNAME}/workspace

# Exponer puerto de Jekyll
EXPOSE 4000

CMD ["bash"]