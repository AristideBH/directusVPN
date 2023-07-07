FROM directus/directus:10.4.2

USER root
RUN corepack enable \
  && corepack prepare pnpm@8.3.1 --activate

USER node
RUN pnpm install directus-extension-editorjs