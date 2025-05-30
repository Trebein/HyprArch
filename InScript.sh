#!/bin/bash

PACKAGES_HYPR=(hyprpaper hyprlock waybar nwg-dock-hyprland)
PACKAGES_MAIN=(nano dmidecode xarchiver thunar fastfetch flatpack git mc meson fish pkgfile)
PACKAGES_FONTS=(ttf-font-awesome otf-font-awesome ttf-jetbrains-mono)
PACKAGES_FISH=(fish pkgfile ttf-dejavu powerline)
PACKAGES_THEME=(nwg-look papirus-icon-theme)



echo -e "\e[1;32m
=======================================================
=======================================================
                Включение multilib
=======================================================
=======================================================
\e[0m"
sed -i '/^#\[multilib\]/{n;s/^#//;s/^#//}' /etc/pacman.conf

echo -e "\e[1;32m
=======================================================
=======================================================
                Обновление системы
=======================================================
=======================================================
\e[0m"
sudo pacman -Syu


echo -e "\e[1;32m
=======================================================
=======================================================
                     Установка YAY
=======================================================
=======================================================
\e[0m"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
rm -rf yay

echo -e "\e[1;32m
=======================================================
=======================================================
             Установка основных пакетов
=======================================================
=======================================================
\e[0m"
sudo pacman -S --noconfirm "${PACKAGES_MAIN[@]}"
sudo pacman -S --noconfirm "${PACKAGES_HYPR[@]}"
yay -S hyprshot github-desktop --noconfirm

echo -e "\e[1;32m
=======================================================
=======================================================
                  Установка шрифтов
=======================================================
=======================================================
\e[0m"
sudo pacman -S --noconfirm "${PACKAGES_FONTS[@]}"

echo -e "\e[1;32m
=======================================================
=======================================================
              Установка FISH и зависимостей
=======================================================
=======================================================
\e[0m"
sudo pacman -S --noconfirm "${PACKAGES_FISH[@]}"

echo -e "\e[1;32m
=======================================================
=======================================================
              Установка менеджера GTK тем
=======================================================
=======================================================
\e[0m"

sudo pacman -S --noconfirm "${PACKAGES_THEME[@]}"
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme/
./install.sh
cd
rm -rf Graphite-gtk-theme

echo -e "\e[1;32m
=======================================================
=======================================================
              Установка и настройка wlogout
=======================================================
=======================================================
\e[0m"
git clone https://github.com/ArtsyMacaw/wlogout.git
cd wlogout
meson build
ninja -C build
sudo ninja -C build install
cd
rm -rf wlogout

echo -e "\e[1;32m
=======================================================
=======================================================
                Копирование конфигов
=======================================================
=======================================================
\e[0m"

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

echo -e "\e[1;32m
=======================================================
=======================================================
             Применение GTK темы и иконок
=======================================================
=======================================================
\e[0m"
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
gsettings get org.gnome.desktop.interface icon-theme # вывод текущих иконок
gsettings set org.gnome.desktop.interface gtk-theme Graphite-Dark
gsettings get org.gnome.desktop.interface gtk-theme # вывод текущей темы

echo -e "\e[1;32m
=======================================================
=======================================================
                   Подключение flathub
=======================================================
=======================================================
\e[0m"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo




echo -e "\e[1;32m
=======================================================
=======================================================

                  Последний штрих:
                       долгая
                         и
                   ОЧЕНЬ ДОЛГАЯ
             установка Flatpak пакетов

=======================================================
=======================================================
\e[0m"
flatpak install flathub org.telegram.desktop
flatpak install flathub com.brave.Browser
flatpak install flathub md.obsidian.Obsidian

echo -e "\e[1;32m
=======================================================
=======================================================
         Скрипт завершен, нужно сделать reboot
=======================================================
=======================================================
\e[0m"
