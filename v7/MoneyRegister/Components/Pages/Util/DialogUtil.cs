using MudBlazor;
using MoneyRegister.Data.Entities;
using MoneyRegister.Components.Pages.Dialogs;

namespace MoneyRegister.Components.Pages.Util;

public class DialogUtil
{
    public static async Task<DialogResult> ShowAccountDialog(IDialogService dialogService, bool isNew, RecurringTransaction recurringTransaction)
    {
        var parameters = new DialogParameters<EditRecurringTransaction>
        {
            { x => x.IsNew, isNew },
            { x => x.RecurringTransactionDetails, recurringTransaction }
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<EditRecurringTransaction>(isNew ? "New Recurring Transaction" : "Edit Recurring Transaction", parameters, options);
        return await dialog.Result;
    }
}
