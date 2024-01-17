using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace WPFMannsMoneyRegister.Data.Migrations
{
    /// <inheritdoc />
    public partial class _000init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Accounts",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    StartingBalance = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    CurrentBalance = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    OutstandingBalance = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    OutstandingItemCount = table.Column<int>(type: "INTEGER", nullable: false),
                    AccountNumber = table.Column<string>(type: "TEXT", nullable: false),
                    InterestRate = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    LoginUrl = table.Column<string>(type: "TEXT", nullable: false),
                    LastBalancedUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Accounts", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Settings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    DefaultAccountId = table.Column<Guid>(type: "TEXT", nullable: false),
                    SearchDayCount = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Settings", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "TransactionGroups",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TransactionGroups", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "RecurringTransactions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    NextDueDate = table.Column<DateTime>(type: "TEXT", nullable: true),
                    Amount = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    BankTransactionText = table.Column<string>(type: "TEXT", nullable: false),
                    BankTransactionRegEx = table.Column<string>(type: "TEXT", nullable: false),
                    RecurringFrequencyType = table.Column<string>(type: "TEXT", nullable: false),
                    FrequencyValue = table.Column<int>(type: "INTEGER", nullable: true),
                    FrequencyDayOfWeekValue = table.Column<int>(type: "INTEGER", nullable: true),
                    FrequencyDateValue = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionGroupId = table.Column<Guid>(type: "TEXT", nullable: true),
                    TransactionType = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecurringTransactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RecurringTransactions_TransactionGroups_TransactionGroupId",
                        column: x => x.TransactionGroupId,
                        principalTable: "TransactionGroups",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Link_Category_RecurringTransactions",
                columns: table => new
                {
                    CategoryId = table.Column<Guid>(type: "TEXT", nullable: false),
                    RecurringTransactionId = table.Column<Guid>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Link_Category_RecurringTransactions", x => new { x.CategoryId, x.RecurringTransactionId });
                    table.ForeignKey(
                        name: "FK_Link_Category_RecurringTransactions_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Link_Category_RecurringTransactions_RecurringTransactions_RecurringTransactionId",
                        column: x => x.RecurringTransactionId,
                        principalTable: "RecurringTransactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Transactions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    Amount = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    AccountId = table.Column<Guid>(type: "TEXT", nullable: false),
                    TransactionType = table.Column<string>(type: "TEXT", nullable: false),
                    TransactionPendingUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionClearedUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    Balance = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    RecurringTransactionId = table.Column<Guid>(type: "TEXT", nullable: true),
                    DueDate = table.Column<DateTime>(type: "TEXT", nullable: true),
                    ConfirmationNumber = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Transactions_Accounts_AccountId",
                        column: x => x.AccountId,
                        principalTable: "Accounts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Transactions_RecurringTransactions_RecurringTransactionId",
                        column: x => x.RecurringTransactionId,
                        principalTable: "RecurringTransactions",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Files",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    Data = table.Column<byte[]>(type: "BLOB", nullable: false),
                    TransactionId = table.Column<Guid>(type: "TEXT", nullable: false),
                    Filename = table.Column<string>(type: "TEXT", nullable: false),
                    ContentType = table.Column<string>(type: "TEXT", nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Files", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Files_Transactions_TransactionId",
                        column: x => x.TransactionId,
                        principalTable: "Transactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Link_Categories_Transactions",
                columns: table => new
                {
                    CategoryId = table.Column<Guid>(type: "TEXT", nullable: false),
                    TransactionId = table.Column<Guid>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Link_Categories_Transactions", x => new { x.CategoryId, x.TransactionId });
                    table.ForeignKey(
                        name: "FK_Link_Categories_Transactions_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Link_Categories_Transactions_Transactions_TransactionId",
                        column: x => x.TransactionId,
                        principalTable: "Transactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedOnUTC", "CurrentBalance", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[,]
                {
                    { new Guid("cd94b889-1782-40ac-8928-fdd8e91bf795"), "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(637), -973.31m, 0m, new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(638), "", "Capital One", "", -110.91m, 3, -862.4m },
                    { new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(627), 2371.79m, 0m, new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(633), "", "Neches FCU", "", -30.91m, 2, 2111.84m }
                });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("035eef39-3acd-47aa-8d5e-5fee02890f96"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(643), "fast-food" },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(641), "bills" },
                    { new Guid("8893122e-d6e9-4cf5-b588-551b37fffcfd"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(650), "medications" },
                    { new Guid("8961dc00-f092-4b2a-8d7f-1d535068142c"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(648), "gas" },
                    { new Guid("b8cd4fc6-beee-4d3c-8589-9e465e5defd3"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(651), "streaming" },
                    { new Guid("e920aca7-7ce1-433f-a9ad-d2a9d1edd49d"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(649), "groceries" }
                });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "BankTransactionRegEx", "BankTransactionText", "CreatedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyValue", "Name", "NextDueDate", "Notes", "RecurringFrequencyType", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("06fe0a29-da51-477c-8aa8-a9fc56ba3b1c"), -83.4m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1171), new DateTime(2024, 1, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Smarter ASP.Net: Etherpunk Web Hosting", new DateTime(2024, 1, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" },
                    { new Guid("3d2bc771-d07d-4d5b-89f1-6796bcf00539"), 378.27m, "", "OPM1 TREAS 310 (XXCIV SERV)", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1287), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "OPM", new DateTime(2024, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", null, "Credit" },
                    { new Guid("54a1b18c-2cec-4ca0-8bc1-2b8f592cf964"), 175m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1268), new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Mom-CellPhone", new DateTime(2024, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", null, "Credit" },
                    { new Guid("88b75db9-4bbb-4410-9f33-5650620a4682"), -70m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1218), null, null, null, "Monique: Dexter Grooming", null, "", "Unknown", null, "Debit" },
                    { new Guid("9fc38f52-2652-410e-b835-f1d5007e907b"), 1998m, "", "SSA TREAS 310 (XXSOC SEC)", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1272), null, 3, 4, "SSDI", new DateTime(2024, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "XWeekOnYDayOfWeek", null, "Credit" },
                    { new Guid("c9192a94-3d64-4c42-9430-96a49f2243af"), -150.47m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1197), new DateTime(2024, 12, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Amazon", new DateTime(2024, 12, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" },
                    { new Guid("de1b419a-5877-450c-8d99-8650db1a75e0"), -15.88m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1184), new DateTime(2024, 10, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Namecheap: Etherpunk DNS", new DateTime(2024, 10, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" },
                    { new Guid("f33d31db-9b6d-41c2-92fb-d208d617474d"), -98.51m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1246), null, null, null, "Bill Clark", null, "", "Irregular", null, "Debit" },
                    { new Guid("f7ca1af8-8cae-404c-a899-2f4196dc3468"), -108.24m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1233), new DateTime(2024, 4, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Office 365", new DateTime(2024, 4, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Settings",
                columns: new[] { "Id", "DefaultAccountId", "SearchDayCount" },
                values: new object[] { 1, new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), 45 });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedOnUTC", "Name" },
                values: new object[] { new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(766), "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "BankTransactionRegEx", "BankTransactionText", "CreatedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyValue", "Name", "NextDueDate", "Notes", "RecurringFrequencyType", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("149a2aa8-b100-4d34-9af7-27436006f5c9"), -150.00m, "", "WEBWELLS FARGO CARD (CCPYMT)", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1106), new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "WF: Windows", new DateTime(2024, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("474d7f37-fa9e-4edd-9267-55a92dd88da3"), -472.12m, "", "WEBUSDA NFC DPRS (ONLINE PMT)", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1024), new DateTime(2023, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Health Insurance", new DateTime(2024, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("5dc5a0c9-4453-486b-8e4a-8e11d58d3a30"), -27.92m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(892), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Apple Services", new DateTime(2024, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("65f4a40e-7ede-4341-bfd4-09050d0cbb3b"), -67.5m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1128), new DateTime(2024, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "WF: A/C", new DateTime(2024, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("74e7bae2-eb83-4c38-bbe1-18e71c2b1190"), -83.36m, "", "Transfer", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1049), new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Personal Loan", new DateTime(2024, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("833c4b83-3ee8-4067-97f4-523853a1fb09"), -12.79m, "", "CA CC GOOGLE.COM GOOGLE*GSUITE", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1000), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Etherpunk", new DateTime(2024, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("85145c0e-722f-4c2b-9eea-b2c25134a890"), -80.72m, "", "TX 800 331 0500 ATT*BILL", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(917), new DateTime(2023, 1, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "AT&T", new DateTime(2024, 2, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("91d9a480-1629-4843-ba73-0da441978204"), -2.99m, "", "", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(865), new DateTime(2023, 1, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Apple iCloud", new DateTime(2024, 2, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("ae85095f-8557-438a-9dfd-37d588b31963"), -104.00m, "", "WEBVENMO (PAYMENT)", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(1075), new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Verizon", new DateTime(2024, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Venmo money to Tim", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("b693609d-7332-49f7-a052-4f84fd30d85e"), -10.81m, "", "CA 408 536 6000 ADOBE INC.", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(789), new DateTime(2023, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Adobe Photoshop", new DateTime(2024, 2, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("ea39baef-58e5-468a-a584-4bf5c267a3a0"), -16.79m, "", "ALLSTATE INS CO (INS PREM)", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(839), new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Allstate Apartment Insurance", new DateTime(2024, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("eb34fecb-47fb-4fa8-aae3-4729b22e58fb"), -719.52m, "", "Transfer", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(943), new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Explorer", new DateTime(2024, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" },
                    { new Guid("f00fc112-649c-49a8-94c9-3b71aa2d2ec6"), -36.81m, "", "TN 888 242 2060 FITNESS YOUR", new DateTime(2024, 1, 17, 15, 28, 47, 905, DateTimeKind.Utc).AddTicks(969), new DateTime(2023, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 9, "Fitness Your Way", new DateTime(2024, 2, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("c214010d-1742-4bf7-b96b-21313edda5e5"), "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "ConfirmationNumber", "CreatedOnUTC", "DueDate", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("0275eb37-b864-4700-a136-b2d9aef959d9"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), 250m, 316.49m, "", new DateTime(2023, 11, 23, 0, 0, 14, 0, DateTimeKind.Unspecified), null, "Mom / Xmas+Birthday", "", null, new DateTime(2023, 12, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" },
                    { new Guid("0cdd5537-ca58-42b9-833a-facd89a6f495"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), 0.06m, 649.11m, "", new DateTime(2023, 11, 23, 0, 0, 9, 0, DateTimeKind.Unspecified), null, "Dividends", "", null, new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" },
                    { new Guid("2cb1faf3-afb6-4179-90db-410b511f59ac"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), 378.27m, 761.84m, "", new DateTime(2023, 11, 23, 0, 0, 6, 0, DateTimeKind.Unspecified), null, "OPM", "", new Guid("3d2bc771-d07d-4d5b-89f1-6796bcf00539"), new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" },
                    { new Guid("6c1b8500-edd7-450f-bf41-fc378e856e2c"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), 175m, 421.49m, "", new DateTime(2023, 11, 23, 0, 0, 16, 0, DateTimeKind.Unspecified), null, "Mom / Cell Phone", "", null, new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("7322d3db-98d3-4b95-8221-74a0f127795f"), new Guid("cd94b889-1782-40ac-8928-fdd8e91bf795"), -30.29m, -892.69m, "", new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Valve", "", null, null, new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("7b68e713-970d-4738-9cdf-f56efef0f4cc"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -500m, 149.11m, "", new DateTime(2023, 11, 23, 0, 0, 10, 0, DateTimeKind.Unspecified), null, "Capital One", "", null, new DateTime(2023, 12, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 12, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("8adf1ea8-81b1-4c47-8869-670164be2e51"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -70m, 246.49m, "", new DateTime(2023, 11, 23, 0, 0, 15, 0, DateTimeKind.Unspecified), null, "Monique / Dexter Grooming", "", null, new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 12, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("9a6c7148-fa34-43c9-a380-90b42da78903"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -100m, 661.84m, "", new DateTime(2023, 11, 23, 0, 0, 7, 0, DateTimeKind.Unspecified), null, "Alice", "Help Alice Rent / Venmo", null, new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("a8cb3546-f64a-4f07-9e75-b2e458699f41"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -838.07m, 1086.41m, "", new DateTime(2023, 11, 23, 0, 0, 2, 0, DateTimeKind.Unspecified), null, "Capital One", "", null, new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("a8cd36d8-de25-4fda-b5b0-52fbffe379f5"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), 1998m, 2371.79m, "", new DateTime(2023, 12, 22, 0, 0, 20, 0, DateTimeKind.Unspecified), null, "SSDI", "", new Guid("9fc38f52-2652-410e-b835-f1d5007e907b"), new DateTime(2023, 12, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("c56aa87f-8bed-43cd-8746-c6f684ae495c"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -35m, 114.11m, "", new DateTime(2023, 11, 23, 0, 0, 11, 0, DateTimeKind.Unspecified), null, "Capital One", "", null, new DateTime(2023, 12, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 12, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("ef3cdb61-37ba-4ec9-b5d1-f1545f0ada21"), new Guid("cd94b889-1782-40ac-8928-fdd8e91bf795"), -70.89m, -973.31m, "", new DateTime(2023, 12, 23, 0, 0, 2, 0, DateTimeKind.Unspecified), null, "SMARTERASP.NET", "", null, null, new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("f861c8d3-a3de-4f0f-9847-72dc1a4eb11a"), new Guid("cd94b889-1782-40ac-8928-fdd8e91bf795"), -9.73m, -902.42m, "", new DateTime(2023, 12, 23, 0, 0, 1, 0, DateTimeKind.Unspecified), null, "Whataburger", "", null, null, new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[] { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("2cb1faf3-afb6-4179-90db-410b511f59ac") });

            migrationBuilder.InsertData(
                table: "Link_Category_RecurringTransactions",
                columns: new[] { "CategoryId", "RecurringTransactionId" },
                values: new object[,]
                {
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("149a2aa8-b100-4d34-9af7-27436006f5c9") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("474d7f37-fa9e-4edd-9267-55a92dd88da3") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("5dc5a0c9-4453-486b-8e4a-8e11d58d3a30") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("65f4a40e-7ede-4341-bfd4-09050d0cbb3b") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("74e7bae2-eb83-4c38-bbe1-18e71c2b1190") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("833c4b83-3ee8-4067-97f4-523853a1fb09") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("85145c0e-722f-4c2b-9eea-b2c25134a890") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("91d9a480-1629-4843-ba73-0da441978204") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("ae85095f-8557-438a-9dfd-37d588b31963") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("b693609d-7332-49f7-a052-4f84fd30d85e") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("ea39baef-58e5-468a-a584-4bf5c267a3a0") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("eb34fecb-47fb-4fa8-aae3-4729b22e58fb") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("f00fc112-649c-49a8-94c9-3b71aa2d2ec6") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "ConfirmationNumber", "CreatedOnUTC", "DueDate", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("05f8aae4-9700-4e2a-9ecb-d54133987233"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -83.36m, 2028.48m, "", new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Personal Loan", "", new Guid("74e7bae2-eb83-4c38-bbe1-18e71c2b1190"), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("2cf9f915-ddd2-4758-9f1c-461208dfd522"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -12.79m, 649.05m, "", new DateTime(2023, 11, 23, 0, 0, 8, 0, DateTimeKind.Unspecified), null, "Etherpunk", "", new Guid("833c4b83-3ee8-4067-97f4-523853a1fb09"), new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("4e3793da-b404-41e5-ac20-51ad1fbbeb65"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -36.81m, 77.30m, "", new DateTime(2023, 11, 23, 0, 0, 12, 0, DateTimeKind.Unspecified), null, "Fitness Your Way", "", new Guid("f00fc112-649c-49a8-94c9-3b71aa2d2ec6"), new DateTime(2023, 12, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("5fe22bc5-b431-457f-9e50-a4ac6cd4cd1e"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -472.12m, 383.57m, "", new DateTime(2023, 11, 23, 0, 0, 5, 0, DateTimeKind.Unspecified), null, "Health Insurance", "", new Guid("474d7f37-fa9e-4edd-9267-55a92dd88da3"), new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("90bac02a-2580-4a88-985d-9d96a39e3acc"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -104.00m, 1924.48m, "", new DateTime(2023, 11, 23, 0, 0, 1, 0, DateTimeKind.Unspecified), null, "Verizon", "", new Guid("ae85095f-8557-438a-9dfd-37d588b31963"), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("93268c9b-323d-4257-823b-194c3de2fe78"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -2.99m, 401.71m, "", new DateTime(2023, 11, 23, 0, 0, 18, 0, DateTimeKind.Unspecified), null, "Apple iCloud", "", new Guid("91d9a480-1629-4843-ba73-0da441978204"), null, null, "Debit" },
                    { new Guid("9c261aa9-528e-43fd-94ac-6a2b9610b23a"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -16.79m, 404.70m, "", new DateTime(2023, 12, 19, 0, 0, 17, 0, DateTimeKind.Unspecified), null, "Allstate Apartment Insurance", "", new Guid("ea39baef-58e5-468a-a584-4bf5c267a3a0"), new DateTime(2023, 12, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("a24f04d7-89b2-48e4-ace5-70025e2fa48b"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -80.72m, 1005.69m, "", new DateTime(2023, 11, 23, 0, 0, 3, 0, DateTimeKind.Unspecified), null, "AT&T", "", new Guid("85145c0e-722f-4c2b-9eea-b2c25134a890"), new DateTime(2023, 11, 26, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("a8e1929b-9613-4c09-9ae4-5cffb2e1b9fe"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -150.00m, 855.69m, "", new DateTime(2023, 11, 23, 0, 0, 4, 0, DateTimeKind.Unspecified), null, "WF: Windows", "", new Guid("149a2aa8-b100-4d34-9af7-27436006f5c9"), new DateTime(2023, 11, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("e57e52e3-97e1-4e58-9468-a726669604f8"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -27.92m, 373.79m, "", new DateTime(2023, 11, 23, 0, 0, 19, 0, DateTimeKind.Unspecified), null, "Apple Services", "", new Guid("5dc5a0c9-4453-486b-8e4a-8e11d58d3a30"), null, null, "Debit" },
                    { new Guid("f4ec1714-a134-44cd-955e-1a09885fd329"), new Guid("daad76d4-ba1d-4c48-ab71-faedb79307e3"), -10.81m, 66.49m, "", new DateTime(2023, 11, 23, 0, 0, 13, 0, DateTimeKind.Unspecified), null, "Adobe Photoshop", "", new Guid("b693609d-7332-49f7-a052-4f84fd30d85e"), new DateTime(2023, 12, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[,]
                {
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("05f8aae4-9700-4e2a-9ecb-d54133987233") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("2cf9f915-ddd2-4758-9f1c-461208dfd522") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("4e3793da-b404-41e5-ac20-51ad1fbbeb65") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("5fe22bc5-b431-457f-9e50-a4ac6cd4cd1e") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("90bac02a-2580-4a88-985d-9d96a39e3acc") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("93268c9b-323d-4257-823b-194c3de2fe78") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("9c261aa9-528e-43fd-94ac-6a2b9610b23a") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("a24f04d7-89b2-48e4-ace5-70025e2fa48b") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("a8e1929b-9613-4c09-9ae4-5cffb2e1b9fe") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("e57e52e3-97e1-4e58-9468-a726669604f8") },
                    { new Guid("0703dbc5-261c-4e3c-927b-dee035a3451e"), new Guid("f4ec1714-a134-44cd-955e-1a09885fd329") }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Files_Name",
                table: "Files",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Files_TransactionId",
                table: "Files",
                column: "TransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Link_Categories_Transactions_TransactionId",
                table: "Link_Categories_Transactions",
                column: "TransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Link_Category_RecurringTransactions_RecurringTransactionId",
                table: "Link_Category_RecurringTransactions",
                column: "RecurringTransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_TransactionGroupId",
                table: "RecurringTransactions",
                column: "TransactionGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_TransactionGroups_Name",
                table: "TransactionGroups",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_AccountId",
                table: "Transactions",
                column: "AccountId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_RecurringTransactionId",
                table: "Transactions",
                column: "RecurringTransactionId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Files");

            migrationBuilder.DropTable(
                name: "Link_Categories_Transactions");

            migrationBuilder.DropTable(
                name: "Link_Category_RecurringTransactions");

            migrationBuilder.DropTable(
                name: "Settings");

            migrationBuilder.DropTable(
                name: "Transactions");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropTable(
                name: "Accounts");

            migrationBuilder.DropTable(
                name: "RecurringTransactions");

            migrationBuilder.DropTable(
                name: "TransactionGroups");
        }
    }
}
