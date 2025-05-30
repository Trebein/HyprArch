#!/bin/bash

# Строгий режим выполнения: прерывание при ошибках, неопределённых переменных и ошибках в пайпах
set -euo pipefail

# Логирование
LOG_FILE="${HOME}/hyprarch_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Функция для логирования ошибок
log_error() {
    local msg="$1"
    echo -e "\e[1;31mОШИБКА: ${msg}\e[0m" >&2
    echo "ОШИБКА: ${msg}" >> "$LOG_FILE"
}

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
sed -i '/^#\[multilib\]/{n;s/^#//;s/^#//}' /etc/pacman.conf || log_error "Не удалось включить multilib"

print_header "Обновление системы"
sudo pacman -Syu || log_error "Не удалось обновить систему"

print_header "Установка YAY"
git clone https://aur.archlinux.org/yay.git || log_error "Не удалось клонировать репозиторий yay"
cd yay || log_error "Не удалось перейти в директорию yay"
makepkg -si || log_error "Не удалось собрать yay"
cd || log_error "Не удалось вернуться в домашнюю директорию"
rm -rf yay || log_error "Не удалось удалить директорию yay"

print_header "Установка основных пакетов"
sudo pacman -S --noconfirm "${PACKAGES_MAIN[@]}" || log_error "Не удалось установить основные пакеты"
sudo pacman -S --noconfirm "${PACKAGES_HYPR[@]}" || log_error "Не удалось установить пакеты Hypr"
yay -S hyprshot github-desktop --noconfirm || log_error "Не удалось установить hyprshot и github-desktop"

print_header "Настройка Bluetooth"
sudo pacman -S --noconfirm "${PACKAGES_BLUETOOTH[@]}" || log_error "Не удалось установить пакеты Bluetooth"
sudo systemctl enable --now tlp || log_error "Не удалось включить службу tlp"

print_header "Настройка звука (PipeWire)"
sudo pacman -S --noconfirm "${PACKAGES_PIPEWIRE[@]}" || log_error "Не удалось установить пакеты PipeWire"

print_header "Настройка сети"
sudo pacman -S --noconfirm "${PACKAGES_NETWORK[@]}" || log_error "Не удалось установить пакеты сети"

print_header "Установка FISH и зависимостей"
sudo pacman -S --noconfirm "${PACKAGES_FISH[@]}" || log_error "Не удалось установить пакеты Fish"

print_header "Настройка игрового пространства"
sudo pacman -S --noconfirm "${PACKAGES_GAME[@]}" || log_error "Не удалось установить игровые пакеты"

print_header "Установка шрифтов"
sudo pacman -S --noconfirm "${PACKAGES_FONTS[@]}" || log_error "Не удалось установить шрифты"

print_header "Установка менеджера GTK тем"
sudo pacman -S --noconfirm "${PACKAGES_THEME[@]}" || log_error "Не удалось установить пакеты тем"
git clone https://github.com/vinceliuice/Graphite-gtk-theme || log_error "Не удалось клонировать репозиторий Graphite"
cd Graphite-gtk-theme/ || log_error "Не удалось перейти в директорию Graphite"
./install.sh || log_error "Не удалось установить тему Graphite"
cd || log_error "Не удалось вернуться в домашнюю директорию"
rm -rf Graphite-gtk-theme || log_error "Не удалось удалить директорию Graphite"

print_header "Установка и настройка wlogout"
git clone https://github.com/ArtsyMacaw/wlogout.git || log_error "Не удалось клонировать репозиторий wlogout"
cd wlogout || log_error "Не удалось перейти в директорию wlogout"
meson build || log_error "Не удалось собрать meson"
ninja -C build || log_error "Не удалось собрать ninja"
sudo ninja -C build install || log_error "Не удалось установить wlogout"
cd || log_error "Не удалось вернуться в домашнюю директорию"
rm -rf wlogout || log_error "Не удалось удалить директорию wlogout"

print_header "Копирование конфигов"
cp -f ~/HyprArch/config-files/BASH/.bashrc ~/ || log_error "Не удалось скопировать .bashrc"
mkdir -p ~/.config/hypr/ || log_error "Не удалось создать директорию hypr"
cp -f ~/HyprArch/config-files/hypr/hyprland.conf ~/.config/hypr/ || log_error "Не удалось скопировать hyprland.conf"
cp -f ~/HyprArch/config-files/hypr/hyprlock.conf ~/.config/hypr/ || log_error "Не удалось скопировать hyprlock.conf"
cp -f ~/HyprArch/config-files/hypr/hyprpaper.conf ~/.config/hypr/ || log_error "Не удалось скопировать hyprpaper.conf"
mkdir -p ~/Wallpapers/ || log_error "Не удалось создать директорию Wallpapers"
cp ~/HyprArch/Wallpapers/light_snow.png ~/Wallpapers/ || log_error "Не удалось скопировать обои"
mkdir -p ~/.config/kitty/ || log_error "Не удалось создать директорию kitty"
cp -f ~/HyprArch/config-files/kitty/kitty.conf ~/.config/kitty/ || log_error "Не удалось скопировать kitty.conf"
cp -rf ~/HyprArch/config-files/waybar ~/.config/ || log_error "Не удалось скопировать конфиги waybar"
cp -rf ~/HyprArch/config-files/wofi ~/.config/ || log_error "Не удалось скопировать конфиги wofi"
cp -rf ~/HyprArch/config-files/fish/ ~/.config/ || log_error "Не удалось скопировать конфиги fish"
mkdir -p ~/.config/fastfetch/ || log_error "Не удалось создать директорию fastfetch"
cp -f ~/HyprArch/config-files/fastfetch/config.jsonc ~/.config/fastfetch/ || log_error "Не удалось скопировать конфиг fastfetch"

print_header "Применение GTK темы и иконок"
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark || log_error "Не удалось установить иконки Papirus-Dark"
gsettings set org.gnome.desktop.interface gtk-theme Graphite-Dark || log_error "Не удалось установить тему Graphite-Dark"

print_header "Подключение flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || log_error "Не удалось добавить репозиторий flathub"

print_header "Последний штрих: долгая и ОЧЕНЬ ДОЛГАЯ установка Flatpak пакетов"
for app in "${FLATPAK_APPS[@]}"; do
    flatpak install -y flathub "$app" || log_error "Не удалось установить $app"
done

print_header "Скрипт завершён! Лог сохранён в $LOG_FILE. Рекомендуется перезагрузка."
