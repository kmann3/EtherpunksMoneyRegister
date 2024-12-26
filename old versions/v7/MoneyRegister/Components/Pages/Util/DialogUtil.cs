using MoneyRegister.Components.Pages.Dialogs;
using MoneyRegister.Data.Entities;
using MudBlazor;

namespace MoneyRegister.Components.Pages.Util;

public class DialogUtil
{
    public static async Task<DialogResult> ShowAccountDialogAsync(IDialogService dialogService, bool isNew, Data.Entities.Account account)
    {
        var parameters = new DialogParameters<AccountDialog>
        {
            { x => x.IsNew, isNew },
            { x => x.AccountDetails, account },
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<AccountDialog>("Account Dialog", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowCategoryDialogAsync(IDialogService dialogService, bool isNew, Category category)
    {
        var parameters = new DialogParameters<CategoryDialog>
        {
            { x => x.CategoryDetails, category },
            { x => x.IsNew, isNew },
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<CategoryDialog>("Category Dialog", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowConfirmDialogAsync(IDialogService dialogService, string title, string buttonText, string contentText, Color color)
    {
        var parameters = new DialogParameters<ConfirmDialog>
        {
            { x => x.ContentText, contentText},
            { x => x.ButtonText, buttonText },
            { x => x.Color, color },
        };

        var options = new DialogOptions() { CloseButton = true, MaxWidth = MaxWidth.ExtraSmall };

        var dialog = await dialogService.ShowAsync<ConfirmDialog>(title, parameters, options);

        return await dialog.Result;
    }
    public static async Task<DialogResult> ShowRecurringTransactionDialogAsync(IDialogService dialogService, bool isNew, RecurringTransaction recurringTransaction)
    {
        var parameters = new DialogParameters<RecurringTransactionDialog>
        {
            { x => x.IsNew, isNew },
            { x => x.RecurringTransactionDetails, recurringTransaction },
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<RecurringTransactionDialog>("Recurring Transaction Dialog", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowReserveTransactionDialog(IDialogService dialogService)
    {
        var parameters = new DialogParameters<ReserveTransactionDialog> { };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<ReserveTransactionDialog>("Select Transactions to Reserve", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowTransactionDialog(IDialogService dialogService, bool isNew, Transaction transaction)
    {
        var parameters = new DialogParameters<TransactionDialog>
        {
            { x => x.TransactionDetails, transaction },
            { x => x.IsNew, isNew },
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<TransactionDialog>("Transaction Dialog", parameters, options);
        return await dialog.Result;
    }
        public static async Task<DialogResult> ShowTransactionFileDialog(IDialogService dialogService, bool isNew, TransactionFile file)
    {
        var parameters = new DialogParameters<TransactionFileDialog>
        {
            { x => x.IsNew, isNew },
            { x => x.File, file },
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<TransactionFileDialog>("Transaction File Dialog", parameters, options);
        return await dialog.Result;
    }
}