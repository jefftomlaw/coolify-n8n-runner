# Dockerfile.js
FROM n8nio/runners:${N8N_VERSION}

USER root

# 1. Install 'pdf-parse' in a separate directory
# We DO NOT use /opt/runners/task-runner-javascript because the beta image 
# has a dirty package.json that breaks pnpm.
RUN mkdir -p /opt/custom-modules \
    && cd /opt/custom-modules \
    && pnpm init \
    && pnpm add pdf-parse

# 2. Fix Permissions
RUN chown -R runner:runner /opt/custom-modules

USER runner
