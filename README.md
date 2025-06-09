# 🐱 meow-colorscripts  
Customize your terminal with cat-themed ANSI art! 🎨🔥  

## 📌 Index  
- [Required](#required)  
- [Available Languages](#languages)  
- [Available Themes](#themes)  
- [Installation](#installation)  
- [Configuration](#configuration)  
- [Update](#update)
- [Command list](#command-list)
- [View Available Cats](#view-available-cats)  
- [Features](#features)  
- [Credits](#credits)  
- [Author](#author)  

## Required  
You need **[Nerd Fonts](https://www.nerdfonts.com/)** to display everything correctly.

## Languages  
The available languages are: English and Spanish.

## Themes  
This project supports several themes and color schemes that enhance your terminal’s aesthetics:

- **Nord Theme**: A clean, elegant arctic color scheme developed by [Sven Greb](https://www.nordtheme.com).  
- **Catppuccin**: A community-driven pastel theme offering variants such as Latte, Frappé, Macchiato, and Mocha.  
- **Everforest**: A soft, low-contrast theme optimized to reduce eye strain.  

Thanks to the creators and communities behind these themes for their amazing work.

## Installation  
To install `meow-colorscripts`, run the following commands in your terminal:  

```bash
git clone https://github.com/Lewenhart518/meow-colorscripts.git
``` 
```bash
cd meow-colorscripts
``` 
```bash
chmod +x install.sh
``` 
```bash
clear && ./install.sh
```  

The installation script will automatically:  
- Set up the required configuration folder.  
- Move the configuration from `~/meow-colorscripts/.config/meow-colorscripts/` to `~/.config/meow-colorscripts/`.  
- Copy necessary files (like `show-meows.sh`).  
- Add the alias `ansi-meow` to your shell configuration.  
- Ask if you want to open the interactive setup immediately.

## Configuration  
Customize your installation using:  

```bash
meow-colorscripts-setup
```  

This command allows you to interactively choose your configuration options:  

- **Select your style** (e.g., *normal*, *nocolor*, a theme such as *nord*, *catpuccin*, *everforest*, or ASCII-based styles: *ascii* and *ascii-color*).  
- **Choose the cat size** (small, normal, large) or the ASCII type (keyboard symbols or blocks, which are treated as “size”) for ASCII styles.  
- **Activate additional commands**:  
  - `meows-names` displays the list of available cat designs.  
  - `show-meow [name]` displays the ANSI art for the specified cat design.  
- **Enable auto-run**: Decide if you want `ansi-meow` to execute automatically when opening a terminal.

During setup, responses are handled interactively:  
- In Spanish, answer with **s** (sí) or **n** (no).  
- In English, answer with **y** (yes) or **n** (no).

## Update  
To update `meow-colorscripts`, follow these steps:

_First time:_
```bash
cd meow-colorscripts
``` 
```bash
chmod +x update.sh
``` 
```bash
./update.sh
```  

_Subsequent updates:_
```bash
cd meow-colorscripts
``` 
```bash
./update.sh
```  

## Command List
The available commands are:

- meow-colorscripts # Displays random ASCII art based on the configuration
- meow-colorscripts-update # Updates the repository and scripts
- meow-colorscripts-setup # Starts the setup process
- meow-colorscripts-names # Displays the list of available art names
- meow-colorscripts-show [style] [size/type] [name] # Displays specific art based on parameters

## View Available Cats  
To view all available cat designs, run:
```bash
meows-names [style] [size (or type in case you chose ascii)] [name]
```  

To display the ANSI art for a specific cat (for example, "raspi"), run:
```bash
meows-show normal normal raspi
```  

## Features  
- High-quality ANSI cat art  
- Easy and fast installation  
- Works across various terminal setups  
- Fully customizable configuration  

## Credits  
`meow-colorscripts` was born from the inspiration of amazing terminal customization projects. Special thanks to:

- **[Pokémon-Colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts)** – For its creative take on terminal colorscripts.  
- **[Meow](https://github.com/PixelSergey/meow)** – For a feline-inspired approach to terminal art.

Their projects played a fundamental role in inspiring this work.

## Author  
Created by **Lewenhart518** 🐱🔥  
[Follow me on GitHub](https://github.com/Lewenhart518)
