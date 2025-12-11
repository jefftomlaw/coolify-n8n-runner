# Dockerfile.js

# 1. Use n8nio/runners as base
FROM n8nio/runners:beta

# 2. Switch to root to install dependencies
USER root

# 3. Install JavaScript Packages in a separate directory
# We no longer need system dependencies like cairo/pango since canvas is gone
RUN mkdir -p /opt/custom-modules \
    && cd /opt/custom-modules \
    && pnpm init \
    && pnpm add \
    pdf-parse

# 4. Fix Permissions
RUN chown -R runner:runner /opt/custom-modules

# 5. Switch back to restricted user
USER runner
