# EtherpunksMoneyRegister

## General

This is a program I plan on using personally. It's more of an ongoing project using whatever framework I'm in the mood for. Written with the goal to replace my spreadsheet eventually

## Versions

v1-v-whatever are simply varying things I'm toying with. Most are incremental however some of the older ones were more ADD of the "Oh, that seems neat - I want to check that out" but v5 and beyond was more comitted to the general idea than language.OS

* :white_check_mark:  v16 : Swift/SwiftUI/SwiftData
* v15 : Swift/SwiftUI/SwiftData - I tried to cheese with ChatGPT and it made some code so much worse it was easier to start over
* v13 : Swift/SwiftUI/SwiftData
* v14 : Swift/SwiftUI/SwiftData
* v12 : Swift/SwiftUI/SwiftData
* v11 : C# /  WPF
* v10 : C# /  WPF
* v9 : C# /  WPF
* v8 : ??? I don't remember
* v7 : C# /  Blazor
* v6 : C# /  Blazor
* v5 : C# /  Blazor
* Deleted previous versions because I didn't think I'd care.
* v4 : C# /  WinUI
* v3 : C# /  WPF
* v2 : C# /  WinForms
* v1 : C# /  WinForms

Currently on v16 - which is Apple focused. MacOS, first. Followed by iOS (mostly iPhone and then iPad), and then by apple Watch.

Apple focused because I bring my Macbook when I travel instead of a Windows or Linux laptop.

Rough order:

* :orange_circle: Account
  * :red_circle: List - Is this even needed?
  * :orange_circle: Detail - copied from older code. Need to re-write from newer code so it visually looks more similar to the new style I like
  * :green_circle: Create
  * :green_circle: Edit

* :orange_circle: Account Transaction
  * :orange_circle: List - still need to work on loading large amounts of transactions. I want it to load the last X (where x is stored in settings) of transactions and load more as needed
  * :orange_circle: Detail - copied from older code. Need to re-write from newer code so it visually looks more similar to the new style I like
    * :red_circle: Files
  * :red_circle: Create - some of the wiring is there but practically nothing
  * :orange_circle: Edit - Mostly done. Need to work more on saving code
    * :orange_circle: Files - Barely started. Basic sheets and UI is there

* :orange_circle: Dashboard
  * :green_circle: Display
  * :green_circle: Nav to bank
  * :green_circle: Nav to reserved transaction
  * :green_circle: Nav to pending transaction
  * :orange_circle: Reserve Credit / paycheck
  * :orange_circle: Reserve Debit Group / bills
  * :orange_circle: Reserve Debit Item / bill

* :red_circle: Recurring Group
  * :red_circle: List
  * :red_circle: Detail
  * :red_circle: Create
  * :red_circle: Edit

* :red_circle: Recurring Transaction
  * :red_circle: List
  * :red_circle: Detail
  * :red_circle: Create
  * :red_circle: Edit
* :red_circle: Reports
  * :red_circle: Tax related

* :red_circle: Search

* :red_circle: Tag
  * :red_circle: List
  * :red_circle: Detail
  * :red_circle: Create
  * :red_circle: Edit

## Various notes / ideas

* Alternate sort methods
* Export/Import: Test: file data, lookups, and link tables
* Unit Testing
* Naming changes: debit/credit bill/paycheck?
* Hard deletes or soft deletes? Currently everything is a hard delete.
* Logging: Should there be a history table which talks about all db changes? This might allow for hard deletes while preserving information
* Session history tracking
  * Recoring changes
  * Back and forward button support
<hr />

* Encrypting important things / encrypting everything / encrypting nothing
* Globalization / Locatlization
* Background service to run bill processing on if something is late?

<hr />
* Do I need to copyright the code? Does it really matter?

## Help Request

* Unit testing. I have no experience here. :(
* Using ChatGPT to help do these
