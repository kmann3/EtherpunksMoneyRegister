# EtherpunksMoneyRegister


## General
This is a program I plan on using personally.

## Versions

v1-v-whatever are simply varying things I'm toying with. They aren't incremental. It's just "oh, that sounds neat, I want to check that out".

Currently doing the v10 WPF version.

Main screen
	- Checkbox for CreatedOn
	- Show icon for showing which sort is enabled
Recurring Transaction
	- Ability to group items


## TBI for WPF


* Toggle-able CreatedOn column for grid.
* Show icon for which column is the one being sorted
* Icons to represent type of transaction?
* Account management
* Category management
* Recurring Transactions. Need a management tool AND the ability to do it on the Transaction List screen. Maybe a dropdown?
* Form validation
* File data - finish
* Export/Import: Test: file data, lookups, and link tables
* Unit Testing
* Hard deletes or soft deletes? Currently everything is a hard delete. 
* Logging: Should there be a history table which talks about all db changes? This might allow for hard deletes while preserving information
* Anything with a NotImeplemented Exception is..... not implemented or thought out well. Still flushing out details.
<hr />

* Encrypting important things. This is a later thing because I'm still manually tweaking things in the database to test and it's simply easier to see mistakes currently.
* Globalization / Locatlization
* Background service to run bill processing on if something is late?

<hr />
* Do I need to copyright the code? Does it really matter?
* Rename dialog files more appropriately. For example: EditTransactionDialog -> TransactionDialog | EdtTransactionFileDialog -> TransactionFileDialog
* Could use some help making the MudBlazor dark theme better. Less purple more blue/green. 

## Help Request

* Unit testing. I have no experience here. :(
