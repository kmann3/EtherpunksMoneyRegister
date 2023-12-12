namespace MoneyRegister.Components.Pages.Util;

public class TreeItemData
{
    public TreeItemData? Parent { get; set; } = null;

    public string Text { get; set; }

    public bool IsExpanded { get; set; } = true;

    public bool IsChecked { get; set; } = false;

    public object? Tag { get; set; }

    public bool HasChild => TreeItems != null && TreeItems.Count > 0;

    public HashSet<TreeItemData> TreeItems { get; set; } = new HashSet<TreeItemData>();

    public TreeItemData(string text)
    {
        Text = text;
    }

    public void AddChild(string itemName)
    {
        TreeItemData item = new TreeItemData(itemName);
        item.Parent = this;
        this.TreeItems.Add(item);
    }

    public void AddChild(TreeItemData item)
    {
        item.Parent = this;
        this.TreeItems.Add(item);
    }

    public bool HasPartialChildSelection()
    {
        int iChildrenCheckedCount = (from c in TreeItems where c.IsChecked select c).Count();
        return HasChild && iChildrenCheckedCount > 0 && iChildrenCheckedCount < TreeItems.Count();
    }
}
