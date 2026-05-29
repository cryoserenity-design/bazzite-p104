FROM ghcr.io/ublue-os/bazzite-nvidia:stable

LABEL org.opencontainers.image.title="bazzite-p104"
LABEL org.opencontainers.image.source="https://github.com/cryoserenity-design/bazzite-p104"

ARG NVIDIA_VERSION=580.159.04

# 1) Качаем оригинальный драйвер с NVIDIA
RUN curl -L -o /tmp/NVIDIA.run \
    "https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run" \
    && chmod +x /tmp/NVIDIA.run

# 2) Распаковываем без установки
RUN /tmp/NVIDIA.run --extract-only --target /tmp/nvidia-driver \
    && rm /tmp/NVIDIA.run

# 3) Качаем патч и распаковываем поверх с заменой файлов
RUN curl -L -o /tmp/nvidia-patch.zip \
    "https://github.com/dartraiden/NVIDIA-patcher/releases/download/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.zip" \
    && dnf install -y unzip \
    && unzip -o /tmp/nvidia-patch.zip -d /tmp/nvidia-driver \
    && rm /tmp/nvidia-patch.zip

# 4) Удаляем старый драйвер
RUN dnf remove -y \
    xorg-x11-drv-nvidia \
    xorg-x11-drv-nvidia-libs \
    xorg-x11-drv-nvidia-cuda \
    akmod-nvidia \
    || true

# 5) Устанавливаем патченный драйвер
RUN /tmp/nvidia-driver/nvidia-installer \
    --silent \
    --no-kernel-module \
    --no-nouveau-check \
    --no-backup \
    && rm -rf /tmp/nvidia-driver
