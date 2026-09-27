--[[

Design ideas:

- nvim_commands.json (name configurable) in root, specifies what commands to run and where to direct the output.
- possibility to automatically open output file in vertical split 
- support interpolation notation,  such as ${file} or ${command}

nvim_commands.json:

{
    "commands": [
        {
            "name": "cargo check",
            "sequence": "",
            "command": "cargo check .",
            "outputFile": "./.cache/cargo_check.txt",
            "autoOpen": true,
            "splitDirection": "right",
            "commandName": "null
        },
        {
            
        },
        {
            
        }
    ]
}


1. Read nvim_comands.json file

2. Create keybinds and user commands.

]]