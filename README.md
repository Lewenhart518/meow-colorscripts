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
- [How use the commands](#How-use-the-commands)
- [View Available Cats](#view-available-cats)
- [Custom](#Custom-meows)
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
  - `meows-colorscripts-names` displays the list of available cat designs.  
  - `meow-colorscripts-show [style] [size] [name]` displays the ANSI art for the specified cat design.  
- **Enable auto-run**: Decide if you want `ansi-meow` to execute automatically when opening a terminal.

During setup, responses are handled interactively:  
- In Spanish, answer with **s** (sí) or **n** (no).  
- In English, answer with **y** (yes) or **n** (no).

## Update  
_To update, follow this simple step:_
```bash
- meow-colorscripts-update
``` 

## Command List
The available commands are:

- meow-colorscripts # Displays random ASCII art based on the configuration
- meow-colorscripts-update # Updates the repository and scripts
- meow-colorscripts-setup # Starts the setup process
- meow-colorscripts-names # Displays the list of available art names
- meow-colorscripts-show [style] [size/type] [name] # Displays specific art based on parameters
- meow-colorscripts-uninstall #This command removes meow-colorscripts if you don't want it anymore.

## How use the commands
1. **meow-colorscripts**  
   - Simply run `meow-colorscripts` to display a random cat design according to your current configuration.
2. **meow-colorscripts-update**  
   - Pulls the latest updates from the repository and refreshes the installed scripts. Use this command regularly to enjoy the latest art and improvements.

3. **meow-colorscripts-setup**  
   - Launches an interactive menu that guides you through configuring your terminal art preferences. You'll be prompted to select a style (normal, nocolor, theme-based, or ASCII), choose the size or ASCII type, decide on extra features, and set up auto-run.

4. **meow-colorscripts-names**  (It only works if you chose it in the setup.)
   - Displays a comprehensive list of the available cat designs. Use this command to see what art designs are available and choose one for display.

5. **meow-colorscripts-show [style] [size] [name]**  (It only works if you chose it in the setup.)
   - Use this command to display a specific cat design. For example:
     
     meow-colorscripts-show normal normal raspi  
     
     This command searches for the file at `~/.config/meow-colorscripts/colorscripts/normal/normal/raspi.txt`.  
     If the file is missing, an error message will prompt you to check the available names using `meow-colorscripts-names` or visit the repository at [GitHub](https://github.com/Lewenhart518/meow-colorscripts).

6. **meow-fact** (It only works if you chose it in the setup.)
   - This command works as follows:
     [command] && meow-fact 
     and this command works for English and Spanish
7. **meow-colorscripts-uninstall**
   just run it to uninstall meow-colorscipts
```bash
meows-colorscipts-show [style] [size] [name]
```  
   
## View Available Cats  
To view all available cat designs, run:
```bash
meows-colorscipts-names
```  

To display the ANSI art for a specific cat (for example, "raspi"), run:
```bash
meows-colorscripts-show normal normal raspi
```  

## Custom meows
you can make your own meow if you put your meow inside the directory ~/.config/meow-colorscripts/colorscripts/[style you chose]/[size/type (if you chose ascii)] or to ~/.config/meow-colorscripts/colorscripts/custom/custom/ and view it with meow-colorscripts-show [name of your carpet] [name of your carpet] [name of your meow]

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
