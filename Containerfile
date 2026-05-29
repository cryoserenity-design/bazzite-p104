FROM ghcr.io/ublue-os/bazzite-nvidia:stable

LABEL org.opencontainers.image.title="bazzite-p104"
LABEL org.opencontainers.image.source="https://github.com/cryoserenity-design/bazzite-p104"

ARG NVIDIA_VERSION=580.159.04

RUN curl -L -o /tmp/NVIDIA.run \
    "https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run" \
    && chmod +x /tmp/NVIDIA.run

RUN /tmp/NVIDIA.run --extract-only --target /tmp/nvidia-driver \
    && rm /tmp/NVIDIA.run

RUN curl -L -o /tmp/nvidia-patch.zip \
    "https://github.com/dartraiden/NVIDIA-patcher/releases/download/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.zip" \
    && unzip -o /tmp/nvidia-patch.zip -d /tmp/nvidia-driver \
    && rm /tmp/nvidia-patch.zip

RUN rm -f /usr/lib64/libnvidia*.so* \
    /usr/lib64/libGL.so* \
    /usr/lib64/libEGL.so* \
    || true

RUN /tmp/nvidia-driver/nvidia-installer \
    --silent \
    --no-kernel-module \
    --no-nouveau-check \
    --no-backup \
    --no-check-for-alternate-installs \
    --ui=none \
    && rm -rf /tmp/nvidia-driver
