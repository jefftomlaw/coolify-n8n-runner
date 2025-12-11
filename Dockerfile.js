# Dockerfile.js

# 1. Use n8nio/runners as base
FROM n8nio/runners:beta

# 2. Switch to root to install dependencies
USER root

# 3. Install JavaScript Packages
# We delete pnpm-lock.yaml first to avoid "Cannot find resolution" errors
# This forces pnpm to resolve dependencies fresh for the new environment.
RUN cd /opt/runners/task-runner-javascript \
    && rm -f pnpm-lock.yaml \
    && pnpm add \
    pdf-lib \
    pdf-img-convert \
    pdf-parse

# 4. Fix Permissions
RUN chown -R runner:runner /opt/runners

# 5. Switch back to restricted user
USER runner
