# SameGame Classic

© 2011 Bayu Rizaldhan Rayes, www.bayubayu.com

![Screenshot](/guide/screenshot.gif)

This is my old flash game template. It was sold at flashden marketplace. Now i'm releasing it as open source.

## Designer & Developer's Guide

### Game Description:

SameGame Classic is an addictive color-matching puzzle game. Click a group of adjoining
jewels of same color to collect them. The goal of this game is to collect items as many as
possible to get the highest score.

## 1. Designer's Guide

SameGame Classic comes with default theme. And in this guide will tell you about how to
customize the game's look and feel. You can easily modify the artwork, button styles,
dialogs, etc. Modify it by editing the .fla file named ClassicSamegame.fla (this file can
be opened in Flash CS3 or later version). After the file has opened, then look at the main
timeline.

![Image 1 Main Timeline](/guide/screenshot1.png)

Main timeline is simple and well organized. It basically consists of **three important
keyframes: assets, titleScreen and play.**

a. Assets keyframe

This frame stores all objects (visual assets) used in the game. You can customize logo,
start game dialog, gameover dialog, etc.

![Image 2 Visual Assets](/guide/screenshot2.jpg)

b. TitleScreen keyframe

You can modify title screen here.

![Image 3 Title Screen](/guide/screenshot3.jpg)

c. Play keyframe

This frame consist of background used in in-game play. You can change it with your own
theme.

![Image 4 In-Game Play](/guide/screenshot4.jpg)

And yes, customization is very easy to do :-)

## 2. Developer's Guide

Okay, now we are talking about the code. This guide is a reference for developer who
wants to change the gameplay or someone who wants to learn the
code. ClassicSameGame is built using ActionScript 3 (AS3) and applies OOP (Object
Oriented Programming Methodology). I try to keep the framework well-structured but not
too complex. The source files also well-commented so you can learn how it works. If you
don’t want to go deeply and only want to do some simple customization, then I've noted
some important lines to be edited. Just read through this tutorial (Important Variable
section).

You can open .as files in your favourite text editor. I would like to recommend
FlashDevelop for easy editing. There is flashdevelop project's file included for those who
use FlashDevelop.

### Classes

ClassicSameGame consist of basic class:

* ClassicSameGame
    
    This is main class for the game.

* LevelData
    
    Class for level data object.

* PopText
    
    Class for animated text score.

* StartLevelBoard

    Class for start level display.

* GameOverBoard

    Class for game over display.
    
* Tile

    Class for tile object.

### Important Variable

If you are familiar with AS3, you can just go into the code. For you that dont want to go
deeply into the code, here is an important variables for customization guide.
Introduction:

This is a samegame puzzle game, so basically there are tiles of balls (or diamonds, or
whatever you want). Tiles are represented by 2-dimensional arrays.

ClassicSameGame.as    

Line 36:

```actionscript
private const TILE_SIZE = 20; // Tile size (width and height)
```

This will modify individual tile dimension (width and height in pixel). If you want to make this
game smaller/bigger by modifying movie size (the default is --------), and want to change tile
size, this variable is what should be edited.

Line 72:

```actionscript
// Options
private var optionEnableSelectFirst:Boolean = false; // enable select
balls before destroyed (needs 2x click to destroy)
private var optionEnableHoverSelect:Boolean = true; // enable hover
select
if you want to click to select tiles and click again to destroy them
(good for touchscreen/mobile game), set
optionEnableSelectFirst:Boolean = true;
and
optionEnableHoverSelect:Boolean = false;
```

ClassicSameGame.as startGame method:

Line 100:

```actionscript
// Tiles layout settings
map_height = 10; // Set Tiles height
map_width = 16; // Set Tiles width
start_x= 33; // Set tiles left
start_y= 79; // Set tiles top
padding= 12; // Set tiles padding

map_height is number of tiles row.
map_width is number of tiles columns.

start_x is keft position of tiles.
start_y is top position of tiles.
```

Padding is distance between tiles.
By modifying those variable you can customize tiles look and feel.

## High Score Setup Guide

This game has a built in high score system using php in server-side. This guide will show you
also about how to install highscore:

1. Upload highscore file.

    You must upload highscore.php to your website hosting directory, so it can be
    accessed via browser, i.e:
    http://yourdomain/flashhighscore/highscores.php

2. Prepare & upload a text file to store data.

    There is a template file named : ClassicSameGame.score.php. Rename it if
    neccessary, but always keep the original file. The basic pattern for filename is
    gamename.score.php, replace gamename with your own game title, for example if
    your game title is ClassicSameGame then score file is:

    ClassicSameGame.score.php

    Then upload this file also in the same folder with highscore.php. Set permission with
    chmod, add read & write permission to this file (octal:666).

3. Modify actionscript file

    Open GameOverBoard.as file. And then find function named
    submitScoreButtonClick(mouseEvent:MouseEvent).
    Modify highscoreGameURL with your actual highscores.php address (see point 1).

    Modify highscoreGameName with your own game title (must be the same name with
    name used at point 2).

Then test it :-)

### Remove built-in highscore

If you dont want to use highscore, simply modify game over dialog to not display submit
highscore button and player name input.

At main timeline, Goto assets keyframe, you can see game over dialog. Double click to
modify it. Hide highscore button by moving it at distance that outside main stage size.
(Note: If you want to completely delete the button, you should also delete all reference to
submitScoreButton. At GameOverBoard.as, delete all reference to submitScoreButton
variable).

### Using another high score system/API

If You want to implement you own highscore system or third party highscore system, open
GameOverBoard.as and find function named
submitScoreButtonClick(mouseEvent:MouseEvent), and then modify the implementation :-)