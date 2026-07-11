FROM python:3.12-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --uid 1000 hermes
USER hermes
WORKDIR /home/hermes
ENV PATH="/home/hermes/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir hermes-agent anthropic

CMD ["hermes", "--help"]
