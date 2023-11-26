from clojure:temurin-17-tools-deps-bullseye

ENV BB_COMMIT=965c177bca31ae9882c975ef7db448e12f59984e
ENV TAILWIND_VERSION=v3.2.4

RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
RUN curl -s https://raw.githubusercontent.com/babashka/babashka/$BB_COMMIT/install | bash
RUN curl -L -o /usr/local/bin/tailwindcss \
  https://github.com/tailwindlabs/tailwindcss/releases/download/$TAILWIND_VERSION/tailwindcss-linux-x64 \
  && chmod +x /usr/local/bin/tailwindcss

WORKDIR /app
COPY resources ./resources
COPY src ./src
COPY bb ./bb
COPY bb.edn config.edn deps.edn .
RUN mkdir -p target/resources/public/css
RUN tailwindcss \
  -c resources/tailwind.config.js \
  -i resources/tailwind.css \
  -o target/resources/public/css/main.css \
  --minify \
  && rm /usr/local/bin/tailwindcss

EXPOSE 8080

CMD ["/bin/sh", "-c", "$(bb --force -e nil; bb run-cmd)"]
