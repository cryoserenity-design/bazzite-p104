FROM ghcr.io/ublue-os/bazzite-nvidia:stable

LABEL org.opencontainers.image.title="bazzite-p104"
LABEL org.opencontainers.image.source="https://github.com/cryoserenity-design/bazzite-p104"

# Устанавливаем зависимости
RUN dnf install -y \
    python3 \
    patchelf \
    git \
    && dnf clean all

# Скачиваем патчер
RUN git clone https://github.com/dartraiden/NVIDIA-patcher.git /tmp/nvidia-patcher

# Находим версию драйвера и патчим библиотеку
RUN cd /tmp/nvidia-patcher && \
    LIB=$(find /usr/lib64 /usr/lib -name "libnvidia-cfg.so.*" 2>/dev/null | head -1) && \
    echo "Found library: $LIB" && \
    python3 patch.py "$LIB" && \
    rm -rf /tmp/nvidia-patcher
