FROM golang:bullseye

RUN apt-get update && apt-get -y install make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git gcc jq zsh bat exa vim \
    python3-pip python3-dev

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    mkdir /antigen && \
    curl -L git.io/antigen > /antigen/antigen.zsh

COPY dotfiles/.zshrc /root/.zshrc
COPY dotfiles/.vimrc /root/.vimrc

COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

WORKDIR /trufflehog
RUN git clone https://github.com/trufflesecurity/trufflehog.git src && \
    cd src && go install

RUN zsh -c 'source /root/.zshrc'

WORKDIR /repos
CMD ["zsh"]