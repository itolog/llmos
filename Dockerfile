# ===================== Build Stage =========================
FROM oven/bun AS build

ARG OUTPUT_FILE=llmos

WORKDIR /app

COPY package.json package.json
COPY bun.lock bun.lock

RUN bun install

COPY ./src ./src

ENV NODE_ENV=production

RUN bun build \
    --compile \
    --minify-whitespace \
    --minify-syntax \
    --outfile ${OUTPUT_FILE} \
    src/main.ts

# ===================== Final Stage =========================
FROM gcr.io/distroless/base

WORKDIR /app

ARG OUTPUT_FILE=llmos
COPY --from=build /app/${OUTPUT_FILE} ${OUTPUT_FILE}
