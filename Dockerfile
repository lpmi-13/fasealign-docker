FROM ubuntu:16.04

# working directory
ENV HOME /root
WORKDIR $HOME

# packages list
RUN \
    apt-get update && apt-get install -y \
    libc6-dev-i386 \
    libx11-dev \
    gawk \
    python-dev \
    python-pip \
    sox \
    curl \
    git

# pip
RUN pip install --upgrade pip==9.0.3

# grab the htk source
RUN git clone https://github.com/loretoparisi/htk

WORKDIR $HOME/htk/
RUN ./configure --disable-hslab && \
    make all && \
    make install

WORKDIR $HOME

# grabs the audiolabel dependency, not available via pip for some reason
RUN git clone https://github.com/rsprouse/audiolabel

WORKDIR $HOME/audiolabel
RUN python setup.py install

WORKDIR $HOME

# installs the faseAlign 
RUN pip install git+git://github.com/EricWilbanks/faseAlign --upgrade

# install more dependencies
RUN pip install numpy pandas

RUN echo export LC_ALL=en_US.UTF-8 >> ~/.bashrc \
    echo export LC_ALL=en_US.UTF-8 >> ~/.profile \
    echo export LANG=en_US.UTF-8 >> ~/.bashrc \
    echo export LANG=en_US.UTF-8 >> ~/.profile \
    echo export LANGUAGE=en_US.UTF-8 >> ~/.bashrc \
    echo export LANGUAGE=en_US.UTF-8 >> ~/.profile \
    source ~/.bashrc \

## this is where the process will be listening
#EXPOSE 9876
#
#CMD ["bash"]

