#!/bin/bash

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
sudo pacman -S git hyprpaper hyprlock waybar mc thunar meson flatpack fastfetch nwg-dock-hyprland --noconfirm
yay -S hyprshot github-desktop --noconfirm

echo -e "\e[1;32m
=======================================================
=======================================================
                  Установка шрифтов
=======================================================
=======================================================
\e[0m"
sudo pacman -S ttf-font-awesome otf-font-awesome ttf-jetbrains-mono --noconfirm

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
              Установка FISH и зависимостей
=======================================================
=======================================================
\e[0m"
sudo pacman -S fish pkgfile ttf-dejavu powerline

echo -e "\e[1;32m
=======================================================
=======================================================
              Установка менеджера GTK тем
=======================================================
=======================================================
\e[0m"
sudo pacman -S nwg-look papirus-icon-theme
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme/
./install.sh
cd
rm -rf Graphite-gtk-theme

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
