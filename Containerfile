FROM ghcr.io/ublue-os/bazzite-nvidia:stable

# Метаданные
LABEL org.opencontainers.image.title="bazzite-p104"
LABEL org.opencontainers.image.description="Bazzite KDE with patched NVIDIA driver for P104-100 mining card"
LABEL org.opencontainers.image.source="https://github.com/cryoserenity-design/bazzite-p104"

# Зависимости для патчера
RUN rpm-ostree install \
    python3 \
    patchelf \
    && ostree container commit

# Скачиваем патчер и применяем к уже установленному драйверу
RUN git clone https://github.com/dartraiden/NVIDIA-patcher.git /tmp/nvidia-patcher \
    && cd /tmp/nvidia-patcher \
    && DRIVER_VERSION=$(cat /usr/share/nvidia/version 2>/dev/null || rpm -q --qf '%{VERSION}' xorg-x11-drv-nvidia 2>/dev/null | head -1) \
    && echo "Patching NVIDIA driver version: ${DRIVER_VERSION}" \
    && python3 patch.py /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.${DRIVER_VERSION} || \
       python3 patch.py $(find /usr/lib* -name "libnvidia-cfg.so.*" | head -1) \
    && rm -rf /tmp/nvidia-patcher \
    && ostree container commit
