![KeepMeFocused](https://github.com/Abu-ZaydAbdullah/KeepMeFocused/blob/master/img/icon.png)

## Overview

This is a Hammerspoon configuration that allows you to specify distracting applications and websites you would like to block to allow you to concentrate on your current task. 

![KeepMeFocused](https://github.com/Abu-ZaydAbdullah/KeepMeFocused/blob/master/img/menubar.png)

## Setup

### Prerequisites

+ Hammerspoon (macOS only)
### Usage

Clone this repository and then add the following statement into your init.lua file:

```lua
local focus = require 'focus'
```

To blacklist applications and websites add them to their respective array in the focus.lua file. 

```lua
-- Place applications you want to block in this array in the format "app_name","other_app_name"...
-- Example:
blacklist_applications = {"Safari"} 

-- Place websites you want to block in this array in the format "domain_name","other_domain_name"...
--Example:
blacklist_websites = {"medium.com"}
```

## Looking Forward

At this current time this project is a minimum viable product, but many features are planned. Ultimately this project aims to offer a feature filled and **free** application that can be used independently of the Hammerspoon application.

## Found any Bugs/Want to Contribute

If you find any bugs or simply want to contribute please submit a pull request.
