# 1. Use n8nio/runners as base (Source: [2])
FROM n8nio/runners:beta

# 2. Switch to root to install dependencies (Source: [2])
USER root

# 3. Install System Dependencies (OCR, etc.) (Source: [2])
RUN apk add --no-cache \
    tesseract-ocr \
    tesseract-ocr-data-eng \
    poppler-utils \
    jpeg-dev \
    zlib-dev \
    build-base \
    python3-dev

# 4. Install JavaScript Packages (Source: [3])
# We cd into the JS runner directory so pnpm updates the correct package.json
RUN cd /opt/runners/task-runner-javascript \
    && pnpm add \
    pdf-lib \
    pdf-img-convert \
    pdf-parse

# 5. Install Python Libraries (Source: [3])
# We cd into the Python runner directory so 'uv' updates the correct venv
RUN cd /opt/runners/task-runner-python \
    && uv pip install \
    pytesseract \
    pdf2image \
    Pillow

# 6. Copy the configuration file to allowlist the packages (Source: [4])
COPY n8n-task-runners.json /etc/n8n-task-runners.json

# 7. Fix Permissions (Source: [3])
RUN chown -R runner:runner /opt/runners

# 8. Switch back to restricted user (Source: [3])
USER runner
