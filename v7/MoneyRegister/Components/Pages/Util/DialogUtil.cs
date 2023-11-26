﻿using MudBlazor;
using MoneyRegister.Data.Entities;
using MoneyRegister.Components.Pages.Dialogs;

namespace MoneyRegister.Components.Pages.Util;

public class DialogUtil
{
    public static async Task<DialogResult> ShowAccountDialogAsync(IDialogService dialogService, bool isNew, RecurringTransaction recurringTransaction)
    {
        var parameters = new DialogParameters<RecurringTransactionDialog>
        {
            { x => x.IsNew, isNew },
            { x => x.RecurringTransactionDetails, recurringTransaction }
        };

        DialogOptions options = new()
        {
            CloseOnEscapeKey = true,
        };

        var dialog = await dialogService.ShowAsync<RecurringTransactionDialog>(isNew ? "New Recurring Transaction" : "Edit Recurring Transaction", parameters, options);
        return await dialog.Result;
    }

    public static async Task<DialogResult> ShowCategoryDialogAsync(IDialogService dialogService, bool isNew, Category category)
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

    public static async Task<DialogResult> ShowConfirmDialogAsync(IDialogService dialogService, string title, string buttonText, string contentText, Color color)
    {
        var parameters = new DialogParameters<ConfirmDialog>
        {
            {x => x.ContentText, contentText},
            {x => x.ButtonText, buttonText },
            {x => x.Color, color }
        };

        var options = new DialogOptions() { CloseButton = true, MaxWidth = MaxWidth.ExtraSmall };

        var dialog = await dialogService.ShowAsync<ConfirmDialog>(title, parameters, options);

        return await dialog.Result;
    }
}