FROM golang:bullseye

RUN apt-get update && apt-get -y install make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git gcc jq zsh bat exa vim \
    python3-pip python3-dev nodejs

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/etc/poetry python3 - && \
    mkdir /etc/antigen && \
    curl -L git.io/antigen > /etc/antigen/antigen.zsh

RUN chsh -s $(which zsh)

COPY dotfiles/.zshrc /root/.zshrc
COPY dotfiles/.vimrc /root/.vimrc

COPY dependencies/requirements.txt .
RUN python3 -m pip install -r requirements.txt

COPY dependencies/node_pkgs.txt .
ENV NVM_VERSION "stable"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install $NVM_VERSION && \
    nvm use $NVM_VERSION && \
    nvm alias default $NVM_VERSION && \
    npm i -g $(cat node_pkgs.txt)

WORKDIR /tools
RUN git clone https://github.com/wireghoul/graudit

WORKDIR /tools/trufflehog
RUN git clone https://github.com/trufflesecurity/trufflehog.git src && \
    cd src && go install

RUN zsh -c 'source /root/.zshrc'

WORKDIR /repos
CMD ["zsh"]