#!/bin/bash

# Строгий режим выполнения: прерывание при ошибках, неопределённых переменных и ошибках в пайпах
set -euo pipefail

# Логирование
LOG_FILE="${HOME}/hyprarch_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Функция для вывода заголовка
print_header() {
    local msg="$1"
    echo -e "\e[1;32m${msg}\e[0m"
}

# Группировка пакетов в массивы
PACKAGES_HYPR=(hyprpaper hyprlock waybar nwg-dock-hyprland)
PACKAGES_MAIN=(nano dmidecode xarchiver thunar fastfetch flatpack git mc meson fish pkgfile)
PACKAGES_FONTS=(ttf-font-awesome otf-font-awesome ttf-jetbrains-mono)
PACKAGES_FISH=(fish pkgfile ttf-dejavu powerline)
PACKAGES_THEME=(nwg-look papirus-icon-theme)
PACKAGES_BLUETOOTH=(blueman bluez bluez-utils bluez-deprecated-tools tlp)
PACKAGES_PIPEWIRE=(pipewire pipewire-pulse pipewire-jack lib32-pipewire gst-plugin-pipewire wireplumber)
PACKAGES_NETWORK=(dhcpcd)
PACKAGES_GAME=(steam-native-runtime lutris wine)
FLATPAK_APPS=(
    org.chromium.Chromium
    com.brave.Browser
    com.discordapp.Discord
    me.kozec.syncthingtk
    org.telegram.desktop
    md.obsidian.Obsidian
    # io.crow_translate.CrowTranslate
    com.librumreader.librum
    com.obsproject.Studio
    org.keepassxc.KeePassXC
    com.nextcloud.desktopclient.nextcloud
    io.github.shiftey.Desktop
    # de.shorsh.discord-screenaudio
)

print_header "Включение multilib"
sed -i '/^#\[multilib\]/{n;s/^#//;s/^#//}' /etc/pacman.conf

print_header "Обновление системы"
sudo pacman -Syu

print_header "Установка YAY"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
rm -rf yay

print_header "Установка основных пакетов"
sudo pacman -S --noconfirm "${PACKAGES_MAIN[@]}"
sudo pacman -S --noconfirm "${PACKAGES_HYPR[@]}"
yay -S hyprshot github-desktop --noconfirm

print_header "Настройка Bluetooth"
sudo pacman -S --noconfirm "${PACKAGES_BLUETOOTH[@]}"
sudo systemctl enable --now tlp

print_header "Настройка звука (PipeWire)"
sudo pacman -S --noconfirm "${PACKAGES_PIPEWIRE[@]}"
# systemctl --user enable --now pipewire pipewire.socket pipewire-pulse wireplumber

print_header "Настройка сети"
sudo pacman -S --noconfirm "${PACKAGES_NETWORK[@]}"
# sudo systemctl enable --now dhcpcd

print_header "Установка FISH и зависимостей"
sudo pacman -S --noconfirm "${PACKAGES_FISH[@]}"

print_header "Настройка игрового пространства"
sudo pacman -S --noconfirm "${PACKAGES_GAME[@]}"

print_header "Установка шрифтов"
sudo pacman -S --noconfirm "${PACKAGES_FONTS[@]}"

print_header "Установка менеджера GTK тем"
sudo pacman -S --noconfirm "${PACKAGES_THEME[@]}"
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme/
./install.sh
cd
rm -rf Graphite-gtk-theme

print_header "Установка и настройка wlogout"
git clone https://github.com/ArtsyMacaw/wlogout.git
cd wlogout
meson build
ninja -C build
sudo ninja -C build install
cd
rm -rf wlogout

print_header "Копирование конфигов"
cp -f ~/HyprArch/config-files/BASH/.bashrc ~/
mkdir -p ~/.config/hypr/
cp -f ~/HyprArch/config-files/hypr/hyprland.conf ~/.config/hypr/
cp -f ~/HyprArch/config-files/hypr/hyprlock.conf ~/.config/hypr/
cp -f ~/HyprArch/config-files/hypr/hyprpaper.conf ~/.config/hypr/
mkdir -p ~/Wallpapers/
cp ~/HyprArch/Wallpapers/light_snow.png ~/Wallpapers/
mkdir -p ~/.config/kitty/
cp -f ~/HyprArch/config-files/kitty/kitty.conf ~/.config/kitty/
cp -rf ~/HyprArch/config-files/waybar ~/.config/
cp -rf ~/HyprArch/config-files/wofi ~/.config/
cp -rf ~/HyprArch/config-files/fish/ ~/.config/
mkdir -p ~/.config/fastfetch/
cp -f ~/HyprArch/config-files/fastfetch/config.jsonc ~/.config/fastfetch/
# докс?

print_header "Применение GTK темы и иконок"
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
# gsettings get org.gnome.desktop.interface icon-theme # вывод текущих иконок
gsettings set org.gnome.desktop.interface gtk-theme Graphite-Dark
# gsettings get org.gnome.desktop.interface gtk-theme # вывод текущей темы

print_header "Подключение и установка Snap"
# git clone https://aur.archlinux.org/snapd.git
# cd snapd && makepkg -si --noconfirm && cd ~
# sudo systemctl enable --now snapd.socket
# sudo snap install tradingview

print_header "Подключение flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

print_header "Последний штрих: долгая и ОЧЕНЬ ДОЛГАЯ установка Flatpak пакетов"
for app in "${FLATPAK_APPS[@]}"; do
    flatpak install -y flathub "$app"
done

print_header "Скрипт завершён! Лог сохранён в $LOG_FILE. Рекомендуется перезагрузка."
