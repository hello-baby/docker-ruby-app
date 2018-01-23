FROM eu.gcr.io/baby-snap-173700/ruby:2.5.0

RUN apt-get update -qq && \
    apt-get install -y locales build-essential libpq-dev sudo vim iputils-ping tzdata && \
    rm -rf /var/lib/apt/lists/*

# Set LOCALE to UTF8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN gem update --system $RUBYGEMS_VERSION && gem install --force bundler

ENV USER apps
ENV APP app

ENV GEM_HOME /.gem
ENV PATH $GEM_HOME/bin:$PATH
ENV BUNDLE_APP_CONFIG $GEM_HOME

ENV HOME /home/$USER
RUN adduser --disabled-password --gecos '' $USER && \
    adduser $USER sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p $GEM_HOME && chown -R $USER $GEM_HOME

RUN mkdir $HOME/$APP
WORKDIR $HOME/$APP

RUN chown $USER:$USER $HOME/$APP && \
    chown -R $USER:$USER /usr/local/lib/ruby/gems/$RUBY_MAJOR.0/doc

RUN adduser $USER root

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
