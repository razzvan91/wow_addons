# Dominos Changelog

8.3.9

* Fix an error when any of the mirror timers end
* Added an option to the cast bar to hide the spark/gradient texture

8.3.8

* Fixed a bug causing the vehicle button to not show up when it should
* Fixed an issue causing the castbar to sometimes get stuck on screen
* Added contextual color option to the castbar for help/harm coloring

8.3.7

* Fixed a bug causing bars with a 0 opacity show state to no longer display cds
* Fixed a bug preventing the options menu from loading in when it should
* Dominos_Config should now load in a bit closer to when its actually needed
* Slightly increased the frame level of Dominos bars for addon compatibility

8.3.6

* Linked bars now inherit fade delay and duration settings

8.3.5

* Add a new option to toggle the latency bar display on the cast bar
* The latency padding option now defaults to your spell queue window

8.3.4

* Fix castbar directions and hopefully reduced jitter

8.3.3

* Fix an error on upgrade.

8.3.2 - The "Jayrgo did a bunch of neat things" update

* Dominos Cast now supports the mirror bars, which display out of breath, exhaustion, etc (thanks to [Jayrgo](https://github.com/Jayrgo))
* Opacity and fade settings have been broken up in to their own menu section, with additional options for controlling fade duration (thanks to [Jayrgo](https://github.com/Jayrgo))
* Dominos now features a new look for its main options menu, and now uses a standard interface for switching profiles.
* Right click menu sections are now listed vertically on the left side to accomidate more options
* Update the default position of the zone ability bar to be more like the position in the stock UI
* Adjusted the show states for the pet bar in classic
* Fixed an issue causing reagent counts to not show for macros in classic (thanks to [Jayrgo](https://github.com/Jayrgo))
* Other minor internal improvements

8.3.1

* Add zone ability bar (shows on the right by default)
* Adjust the PlayerPowerBarAlt repositioning bits to try and prevent the stock UI from continuing to take it over
* Adjust the encounter bar cooldown region to remove gaps

8.3.0

* Update TOCs for 8.3.0

8.2.36

* Fix issue with packager

8.2.35

* Fix bag slot ordering

8.2.34

* Add Shadowburn reagent count
* Fix an issue that would sometimes prevent action counts from being set

8.2.33

* Classic: Abilities that require reagents should now show how many times you can currently cast the ability
* Classic: Moved the keyring icon to the left side of the bag bar
* Replaced the One Bag option with a Show Bag Slots option. If you want to only display the backpack, you'll need to uncheck both the Show Keyring and the Show Bag Slots options.

8.2.32

* Fix display settings for keyring not persisting

8.2.31

* Update TOCs for 1.13.3
* Add keyring support to the bag bar
* Add the ability to control click the backpack button to toggle the key ring

8.2.30

* Updated TOCs for 8.2.5

8.2.29

* Now using the Dominos icon in both retail and classic
* Added the ability to disable Dominos modules on a per profile basis via Dominos.db.profile.modules.ModuleName = false
* Misc internal changes

8.2.28

* Fix an error when channeling spells

8.2.27

* Yet more progress bar bugfixes
* Fix an issue that would cause empty slots to not reappear after switching profiles

8.2.26

* Added a new option Show Count Text - toggles showing item/reagent counts on action buttons
* Updated the artifact bar display to prioritize the azerite bar

8.2.25

* Added a workaround for cases where the progress bar mode update updated failed
* Added druid travel form paging options
* Set statehidden = true on all Blizzard action buttons by default
* Classic - Added counts to action buttons for abilities that consume reagents

8.2.24

* Add a new progress bar mode setting: Skip Inactive modes. Enabling this skip any inactive progress bar mode when you
click a progress bar to switch the next mode

8.2.23

* Revert one bar mode being the default setting for the progress bar.

8.2.22

* Fix an issue preventing the main options panel for the progress bar from loading

8.2.21

* Fix an issue causing druid form states to not work properly if the player has a bar set for Moonkin form without having the form

8.2.20

* Skipped version 8.2.19
* Added a Theme Action Buttons toggle to the main interface window to enable/disable the Dominos look for action buttons
* Added support for the next version of Masque

8.2.18

* Fix a db migration error for completely new profiles

8.2.17

* Add migration bits for the config change introduced in 8.2.16

8.2.16

* Fixed cases where the progress bar would appear blank

8.2.15

* Automated release

8.2.14

* Hide the bag buttons a bit better in one bag mode
* Add latency to the minimap button tooltip when running on classic realms

8.2.13

* Made progress bar modes a per character setting
* Update libraries

8.2.12

* Fix latency frame still appearing in classic

8.2.11

* Fixed menu bar ordering issues
* You can now type in values beyond the normal limits for the spacing and padding sliders. You can also increment beyond limits via holding a modifier key and using the mouse wheel on a slider
* The progress bar will only now switch between active modes on click

8.2.10

* Added a workaround to handle adding appropriate spacing to container frames/quest log when both right bars are checked and not set to be stacked vertically in Blizzard's option menu.

8.2.9

* Rewrote the code for hiding the various bits of Blizzard's UI to handle both the changes in 8.2 around restricted frames and the differences between classic and retail.

8.2.8

* Apply a quick fix for the save bindings error
* Fix an error upon load for the multiactionbars

8.2.7

* WoW 8.2 Release
* Fix some druid forms and shadow form for classic

8.2.6

* Fix shadowdance check

8.2.5

* Fix a typo in the addon TOC * Hide addon options that are not relevant to classic

8.2.4

* Fix a redbox error on exiting combat

8.2.3

* Fix multiactionbar fixer error on classic

8.2.2

* Use Dominos:IsBuild("classic") for tests. * Add stance bar for paladins

8.2.1

* Allow exit vehicle button to load

8.2.0

* Initial release for classic
