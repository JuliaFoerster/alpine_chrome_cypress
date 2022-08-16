FROM node:18-alpine3.15

WORKDIR /cypress-example-kitchensink

COPY ./cypress ./cypress
COPY ./cypress.config.js ./cypress.config.js

# RUN apk --no-cache add curl libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
RUN apk --no-cache add wget curl gtk+3.0-dev libnotify xvfb nss libxscrnsaver alsa-lib glib-dev musl xauth libxtst xkbcomp
RUN apk add xauth xvfb libxtst alsa-lib-dev libxscrnsaver nss libnotify-dev mesa-gbm gtk+3.0 gtk+2.0 gcompat
# gcompat
# useless ffmpeg-libs

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories
RUN apk --no-cache add gconf

# RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
#     wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk && \
#     apk add glibc-2.35-r0.apk

# install Chrome browser
# RUN apk add chromium


# Installs latest Chromium package.
RUN apk upgrade --no-cache --available \
    && apk add --no-cache \
      chromium \
      ttf-freefont \
      font-noto-emoji \
    && apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
      font-wqy-zenhei



ENV CI=1 \
# disable shared memory X11 affecting Cypress v4 and Chrome
# https://github.com/cypress-io/cypress-docker-images/issues/270
  QT_X11_NO_MITSHM=1 \
  _X11_NO_MITSHM=1 \
  _MITSHM=0 \
  # point Cypress at the /root/cache no matter what user account is used
  # see https://on.cypress.io/caching
  CYPRESS_CACHE_FOLDER=/root/.cache/Cypress \
  # Allow projects to reference globally installed cypress
  NODE_PATH=/usr/local/lib/node_modules


# should be root user
RUN echo "whoami: $(whoami)" \
  && npm config -g set user $(whoami) \
  # command "id" should print:
  # uid=0(root) gid=0(root) groups=0(root)
  # which means the current user is root
  && id \
  && npm install -g typescript \
  && npm install -g "cypress@10.5.0"

# RUN cd /root/.cache/Cypress/10.5.0/Cypress/ && ldd ./Cypress

# RUN cypress verify
# RUN npx cypress run --spec "cypress/e2e/1-getting-started/todo.cy.js"
# RUN yarn cypress run --browser /usr/bin/chromium-browser

# RUN (node -p "process.env.CI_XBUILD && process.arch === 'arm64' ? 'Skipping cypress verify on arm64 due to SIGSEGV.' : process.exit(1)" \
#     || (cypress verify \
#     # Cypress cache and installed version
#     # should be in the root user's home folder
#     && cypress cache path \
#     && cypress cache list \
#     && cypress info \
#     && cypress version)) \
#   # give every user read access to the "/root" folder where the binary is cached
#   # we really only need to worry about the top folder, fortunately
#   && ls -la /root \
#   && chmod 755 /root \
#   # always grab the latest Yarn
#   # otherwise the base image might have old versions
#   # NPM does not need to be installed as it is already included with Node.
#   && npm i -g yarn@latest \
#   # Show where Node loads required modules from
#   && node -p 'module.paths' \
#   # should print Cypress version
#   # plus Electron and bundled Node versions
#   && cypress version \
#   && echo  " node version:    $(node -v) \n" \
#     "npm version:     $(npm -v) \n" \
#     "yarn version:    $(yarn -v) \n" \
#     "typescript version:  $(tsc -v) \n" \
#     "user:            $(whoami) \n" \
#     "chrome:          $(chromium-browser --version || true) \n" \

# # Add Chrome as a user
# RUN mkdir -p /usr/src/app \
#     && adduser -D chrome \
#     && chown -R chrome:chrome /usr/src/app
# # Run Chrome as non-privileged
# USER chrome

# WORKDIR /usr/src/app

# ENV CHROME_BIN=/usr/bin/chromium-browser \
#     CHROME_PATH=/usr/lib/chromium/


# ENTRYPOINT ["cypress", "run"]

# RUN npx cypress run


