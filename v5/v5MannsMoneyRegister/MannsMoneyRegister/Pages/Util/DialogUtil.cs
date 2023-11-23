using MannsMoneyRegister.Data.Entities;
using MudBlazor;
using MannsMoneyRegister.Pages.Components;

namespace MannsMoneyRegister.Pages.Util;

public class DialogUtil
{
    public static async Task<DialogResult> ShowAccountDialog(IDialogService dialogService, bool isNew, Account account)
    {
        var parameters = new DialogParameters<Components.AccountDialog>
        {
            { x => x.IsNew, isNew },
            { x => x.AccountDetails, account }
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<AccountDialog>(isNew ? "New Account" : "Edit Account", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowBillDialog(IDialogService dialogService, bool isNew, Bill bill, List<BillGroup> billGroups)
    {
        var parameters = new DialogParameters<BillDialog>
        {
            { x => x.IsNew, isNew },
            { x => x.BillDetails, bill },
            { x => x.BillGroupList, billGroups }
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<BillDialog>(isNew ? "New Bill" : "Edit Bill", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowBillGroupSelectDialog(IDialogService dialogService, List<BillGroup> billGroups, List<Bill> ungroupedBills)
    {
        var parameters = new DialogParameters<ReserveBillDialog>
        {
            { x => x.BillGroupList, billGroups },
            {x => x.BillUngroupedList, ungroupedBills }
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<ReserveBillDialog>("Select Bills To Reserve", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowCategoryDialog(IDialogService dialogService, bool isNew, Category category)
    {
        var parameters = new DialogParameters<CategoryDialog>
        {
            { x => x.CategoryDetails, category },
            { x => x.IsNew, isNew }
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<CategoryDialog>(isNew ? "New Category" : "Edit Category", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowTransactionDialog(IDialogService dialogService, bool isNew, Transaction transaction, List<Account> accountList, List<Category> categoryList)
    {
        var parameters = new DialogParameters<TransactionDialog>
        {
            { x => x.TransactionDetails, transaction },
            { x => x.AccountList, accountList },
            { x => x.CategoryList, categoryList },
            { x => x.IsNew, isNew },
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        string title = string.Empty;
        switch (transaction.TransactionType) {
            case Transaction.EntryType.Credit:
                title = isNew ? "New Deposit" : "Edit Deposit";
                break;
            case Transaction.EntryType.Debit:
                title = isNew ? "New Expense" : "Edit Expense";
                break;
        }

        var dialog = await dialogService.ShowAsync<TransactionDialog>(title, parameters, options);
        return await dialog.Result;
    }
}
