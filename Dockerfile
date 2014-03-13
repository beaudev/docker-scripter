FROM phusion/passenger-full

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Here we go
RUN rm -f /etc/service/nginx/down

ADD nginx-webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN mkdir /home/app/webapp
RUN mkdir /home/app/projects

RUN sudo apt-get install ruby-dev
RUN gem install t

## Install SSH for a specific user (thanks to public key)
ADD ./config/id_rsa.pub /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key

# Add private key in order to get access to private repo
ADD ./config/id_rsa /root/.ssh/id_rsa

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get install screen
