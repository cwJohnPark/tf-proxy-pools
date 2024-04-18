FROM ruby:3.0

ENV RACK_ENV=production HOST=127.0.0.1
ENV TERRAFORM_VERSION=1.8.1
ENV TERRAFORM_ARCHIVE_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

COPY . .

# Generate ssh key 
RUN mkdir .ssh && ssh-keygen -f .ssh/ec2_key -N ''

RUN chmod 755 *.rb

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ARCHIVE_FILE} && \
  unzip ${TERRAFORM_ARCHIVE_FILE} -d /usr/local/bin && \
  rm ${TERRAFORM_ARCHIVE_FILE}

RUN terraform init

EXPOSE 4567

CMD bundle exec ruby app.rb