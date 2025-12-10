FROM n8nio/runners:next

USER root

# 1. Install Dependencies & Build Libraries
RUN apk add --no-cache \
    cairo \
    pango \
    libjpeg-turbo \
    giflib \
    tesseract-ocr \
    tesseract-ocr-data-eng \
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
    # 4. Cleanup
    && apk del .build-deps

# 5. Fix permissions
RUN chown -R runner:runner /opt/runners

# 6. Expose the Health Check Port
EXPOSE 5680

USER runner
