Lumberjack for Garry's Mod (Helix)
A Lumberjack system for Garry's Mod based on the Helix Framework, allowing players to cut down trees, observe their growth, and interact with trees through several stages.

🚀 Description
This plugin adds a progressive growth tree system to Garry's Mod using the Helix Framework. Players can chop down trees, observe their growth through various stages, and use an axe to obtain resources.

Main features:
Trees with progressive growth: The tree goes through several stages:

The stump (after the log house).

A small tree (after 60 seconds).

The middle tree (after 30 seconds).

A large tree (after 30 seconds, which you can interact with).

Felling trees: The player must hold down the E key for 7 seconds in order to cut down a tree. After that, a tree stump appears.

Tree regeneration: After a tree is cut down, it undergoes cyclical restoration:

Stump → Small tree → Medium tree → Large tree.

The tree is restored in the same place where it was cut down after a certain time (60 seconds for small, 30 seconds for medium and large).

Data retention: All tree data, including their position and stage, is saved between server restarts, allowing trees to recover after a restart.

Deleting trees: A tree can be deleted only through a tool gun or through standard removal tools in the Q-menu.

📦 Installation
Download or clone the repository to the garrysmod/addons folder.

Restart the server to download the plugin.

In the Q-menu, go to Entities → Lumberjack → Tree and start the tree.

In order to cut down a tree, get an axe with the command /giveme axe.

Go to the tree and hold E to cut it down.

🔧 Customize
Tree models
All models for different stages of the tree can be configured in ix_tree.lua.:

local treeModels = {
    [0] = "models/props_forest/tree_pine_stump02.mdl", -- Stump
    [1] = "models/props/folder/tree_deciduous_01a-lod.mdl", -- Small tree
    [2] = "models/props/folder/tree_dead03.mdl", -- Middle tree
    [3] = "models/props/folder/tree_dead01.mdl", -- Large tree
}
You can replace these models with any other ones if you want to use your own.

Time of growth
Each tree goes through the following stages:

Stump → Small tree — after 60 seconds.

Small tree → The average tree is in 30 seconds.

Medium tree → Large tree — in 30 seconds.

These time intervals can be changed to suit your needs.

, Additional functions
You can easily add new features or improvements.:

Axe Wear: Add a wear system for the axe so that it breaks after several cuts.

Animations: Add animations for the player when chopping down a tree.

Effects: Realize the effects when cutting down, such as dust or sound effects.

Fertilizer: Add a system for accelerated tree growth using fertilizers.

, System requirements
Garry's Mod (v. 13+)

Helix Framework (v. 1.0+)

Lua 5.1 (included in Garry's Mod)


ix_tree.lua plugin files are the main plugin file that describes the logic of tree growth and felling.

sh_plugin.lua — connects the client and server parts of the plugin, and is also responsible for saving and loading tree data.

cl_plugin.lua — draws a custom progress bar for chopping wood.

sv_plugin.lua — saves tree data (position, stage) between server restarts.

, Important remarks
The tree can only be deleted manually (with a tool bar or via the Q-menu) to prevent accidental deletion.

Chopping wood requires an axe. If the player does not have an axe, chopping will be impossible.

If the tree is not being cut, make sure that it is in the last stage (a large tree).
