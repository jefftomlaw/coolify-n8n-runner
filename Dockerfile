FROM n8nio/runners:latest

USER root

# 1. Install Dependencies & Build Libraries
# We combine everything into one RUN command to keep the image layer small.
RUN apk add --no-cache \
    # Runtime libraries for PDF/Image processing (required by canvas & tesseract)
    cairo \
    pango \
    libjpeg-turbo \
    giflib \
    tesseract-ocr \
    tesseract-ocr-data-eng \
    # Build dependencies (compilers/headers needed to install node-canvas)
    && apk add --no-cache --virtual .build-deps \
    build-base \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    python3-dev \
    # 2. Install JavaScript Packages
    && cd /opt/runners/task-runner-javascript \
    && pnpm add pdf-lib pdf-img-convert pdf-parse \
    # 3. Install Python Libraries
    && cd /opt/runners/task-runner-python \
    && uv pip install markitdown pytesseract Pillow \
    # 4. Clean up build dependencies
    && apk del .build-deps

# REMOVED: COPY n8n-task-runners.json ... (Not needed, using default config)

# 5. Fix permissions (files installed by root must be owned by runner)
RUN chown -R runner:runner /opt/runners

USER runner
