namespace UnitTest;
using MannsMoneyRegister;
using MannsMoneyRegister.Data.Entities;
//using MannsMoneyRegister.Data.Services.Entities;

public class Tests
{
    Transaction transactionTodayFull = new()
    {
        Name = "new",
        TransactionPendingUTC = DateTime.Now,
        TransactionClearedUTC = DateTime.Now
    };

    Transaction transactionMonthOldFull = new()
    {
        Name = "old",
        TransactionPendingUTC = DateTime.Now.AddMonths(-1),
        TransactionClearedUTC = DateTime.Now.AddMonths(-1)
    };

    Transaction transactionTodayOnlyEntered = new()
    {
        Name = "today entered",
        TransactionPendingUTC = DateTime.Now,
        TransactionClearedUTC = null
    };

    Transaction transactionMonthOldOnlyEntered = new()
    {
        Name = "month old entered",
        TransactionPendingUTC = DateTime.Now.AddMonths(-1),
        TransactionClearedUTC = null
    };

    Transaction transactionAllNull = new()
    {
        Name = "null",
        TransactionPendingUTC = null,
        TransactionClearedUTC = null
    };

    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void CompareEverything()
    {
        List<Transaction> list = new List<Transaction>
        {
            transactionTodayFull,
            transactionMonthOldFull,
            transactionTodayOnlyEntered,
            transactionMonthOldOnlyEntered,
            transactionAllNull
        };

        list.Sort(comparer: new Transaction());
        Assert.Multiple(() =>
        {
            Assert.That(list[0].Name, Is.EqualTo(transactionAllNull.Name));
            Assert.That(list[1].Name, Is.EqualTo(transactionTodayOnlyEntered.Name));
            Assert.That(list[2].Name, Is.EqualTo(transactionMonthOldOnlyEntered.Name));
            Assert.That(list[3].Name, Is.EqualTo(transactionTodayFull.Name));
            Assert.That(list[4].Name, Is.EqualTo(transactionMonthOldFull.Name));
        });
    }

    [Test]
    public void CompareOnlyEntered1()
    {
        List<Transaction> list = new List<Transaction>
        {
            transactionTodayOnlyEntered,
            transactionMonthOldOnlyEntered
        };

        list.Sort(comparer: new Transaction());
        Assert.Multiple(() =>
        {
            Assert.That(list.First().Name, Is.EqualTo(transactionTodayOnlyEntered.Name));
            Assert.That(list.Last().Name, Is.EqualTo(transactionMonthOldOnlyEntered.Name));
        });
    }

    [Test]
    public void CompareOnlyEntered2()
    {
        List<Transaction> list = new List<Transaction>
        {
            transactionMonthOldOnlyEntered,
            transactionTodayOnlyEntered
            
        };

        list.Sort(comparer: new Transaction());
        Assert.Multiple(() =>
        {
            Assert.That(list.First().Name, Is.EqualTo(transactionTodayOnlyEntered.Name));
            Assert.That(list.Last().Name, Is.EqualTo(transactionMonthOldOnlyEntered.Name));
        });
    }

    [Test]
    public void CompareFullTransactionNewOld1()
    {
        

        List<Transaction> list = new List<Transaction>
        {
            transactionTodayFull,
            transactionMonthOldFull
        };

        list.Sort(comparer: new Transaction());
        Assert.Multiple(() =>
        {
            Assert.That(list.First().Name, Is.EqualTo("new"));
            Assert.That(list.Last().Name, Is.EqualTo("old"));
        });
    }

    [Test]
    public void CompareFullTransactionNewOld2()
    {
        List<Transaction> list = new List<Transaction>
        {
            transactionMonthOldFull,
            transactionTodayFull
        };

        list.Sort(comparer: new Transaction());
        Assert.Multiple(() =>
        {
            Assert.That(list.First().Name, Is.EqualTo("new"));
            Assert.That(list.Last().Name, Is.EqualTo("old"));
        });
    }
}