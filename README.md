# EtherpunksMoneyRegister


## General
This is a program I plan on using personally.

## What is potential exposure?

Let's assume your database is stolen, someone has physical access (think: hosted solutions). This is worse case scenario if they get a copy of your database.

* Obvious patterns can be inferred. For example a balance of exactly "0.00" will show the same encrypted values all across. They won't _know_ what it is but it's not unreasonable to assume patterns. If you use "admin" for your username and "admin" for your passwords -- those will show the same string. It will dramatically make it easier for them to figure out your encryption string
* Email address is visible.
* NULL's in the databases are still shown as null - implying not used, not yet entered. So a transaction with an encrypted date but a null cleared means one could infer it's new and still processing. This would not be an unreasonable assumption.

## Versions

v1-v-whatever are simply varying things I'm toying with. They aren't incremental. It's just "oh, that sounds neat, I want to check that out".