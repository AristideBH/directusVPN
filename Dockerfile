FROM directus/directus:10.4.3

USER root
RUN corepack enable \
  && corepack prepare pnpm@8.3.1 --activate

USER node
RUN pnpm install directus-extension-editorjs 
RUN pnpm install directus-extension-wpslug-interface
RUN pnpm install @bicou/directus-extension-tiptap
RUN pnpm install directus-extension-group-tabs-interface
RUN pnpm install @wellenplan/directus-extension-duration-interface