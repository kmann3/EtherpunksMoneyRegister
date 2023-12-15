# EtherpunksMoneyRegister


## General
This is a program I plan on using personally.

## Versions

v1-v-whatever are simply varying things I'm toying with. They aren't incremental. It's just "oh, that sounds neat, I want to check that out".

## TBI

* Form validationin pages. Currently there's only base sanity checking. Could help with UX if we displayed the problems as they progressed
* Fix category selection in recurring transaction and transactions.
* RecurringTransactionDetails: Handle file data / ability to download
* Files: Consider a lookup for types of files such as bills, contracts, warranties, etc
* Export/Import: Test: file data, lookups, and link tables
* Polish RecurringTransactionDetails. I don't like how it looks.
* Menu adjust so you see where you are / Nav
* Categories/Tags: Details page for editing and getting an overview of their use
* Unit Testing
* Hard deletes or soft deletes?
* Logging: Should there be a history table which talks about all db changes? This might allow for hard deletes while preserving information
<hr />

* Encrypting important things. This is a later thing because I'm still manually tweaking things in the database to test and it's simply easier to see mistakes currently.
* Globalization / Locatlization
* Background service to run bill processing on if something is late?

<hr />
* Do I need to copyright the code? Does it really matter?
* Rename dialog files more appropriately. For example: EditTransactionDialog -> TransactionDialog | EdtTransactionFileDialog -> TransactionFileDialog
* Could use some help making the MudBlazor dark theme better. Less purple more blue/green. 