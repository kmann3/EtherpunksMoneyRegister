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
                name: "AccountTransactions",
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
                    BankTransactionText = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AccountTransactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AccountTransactions_Accounts_AccountId",
                        column: x => x.AccountId,
                        principalTable: "Accounts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AccountTransactions_RecurringTransactions_RecurringTransactionId",
                        column: x => x.RecurringTransactionId,
                        principalTable: "RecurringTransactions",
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
                name: "Files",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    Data = table.Column<byte[]>(type: "BLOB", nullable: false),
                    AccountTransactionId = table.Column<Guid>(type: "TEXT", nullable: false),
                    Filename = table.Column<string>(type: "TEXT", nullable: false),
                    ContentType = table.Column<string>(type: "TEXT", nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Files", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Files_AccountTransactions_AccountTransactionId",
                        column: x => x.AccountTransactionId,
                        principalTable: "AccountTransactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Link_Categories_Transactions",
                columns: table => new
                {
                    CategoryId = table.Column<Guid>(type: "TEXT", nullable: false),
                    AccountTransactionId = table.Column<Guid>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Link_Categories_Transactions", x => new { x.AccountTransactionId, x.CategoryId });
                    table.ForeignKey(
                        name: "FK_Link_Categories_Transactions_AccountTransactions_AccountTransactionId",
                        column: x => x.AccountTransactionId,
                        principalTable: "AccountTransactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Link_Categories_Transactions_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedOnUTC", "CurrentBalance", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[,]
                {
                    { new Guid("b356926e-041a-479e-b531-daef60b64a23"), "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(69), 2371.79m, 0m, new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(75), "", "Neches FCU", "", -30.91m, 2, 2111.84m },
                    { new Guid("b7ad9496-442a-48a9-85a5-c90abf5d4f6c"), "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(77), -973.31m, 0m, new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(78), "", "Capital One", "", -110.91m, 3, -862.4m }
                });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(81), "bills" },
                    { new Guid("272b0ce7-c43a-4850-ac59-a7b3b6e78812"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(93), "medications" },
                    { new Guid("98f8b3c8-5a4b-40dc-938e-9c535086e092"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(94), "streaming" },
                    { new Guid("9cdb0674-247e-48d0-ac38-7247df637f6c"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(85), "groceries" },
                    { new Guid("a33ef77b-01e9-474e-9ced-520ce3de3801"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(83), "fast-food" },
                    { new Guid("e5a56a00-5d9b-4ae6-bb31-d020c481db32"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(84), "gas" }
                });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "BankTransactionRegEx", "BankTransactionText", "CreatedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyValue", "Name", "NextDueDate", "Notes", "RecurringFrequencyType", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("23cbb976-502c-47ff-bd3e-9d2157ff3c7a"), 1998m, "", "SSA TREAS 310 (XXSOC SEC)", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(740), null, 3, 4, "SSDI", new DateTime(2024, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "XWeekOnYDayOfWeek", null, "Credit" },
                    { new Guid("36cbc06f-90e3-4c56-b1fe-0012efdc4f08"), -83.4m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(646), new DateTime(2024, 1, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Smarter ASP.Net: Etherpunk Web Hosting", new DateTime(2024, 1, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" },
                    { new Guid("72f5977b-4a60-4537-93e3-bd2d4b4a3cd3"), -108.24m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(701), new DateTime(2024, 4, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Office 365", new DateTime(2024, 4, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" },
                    { new Guid("79735ecd-c2aa-4e4e-ae3d-74feb3dbb9b3"), -15.88m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(659), new DateTime(2024, 10, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Namecheap: Etherpunk DNS", new DateTime(2024, 10, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" },
                    { new Guid("871b919c-333e-412d-a28e-965f663005dc"), -70m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(685), null, null, null, "Monique: Dexter Grooming", null, "", "Unknown", null, "Debit" },
                    { new Guid("988c8078-4b59-47fc-8dde-f1cfe603dd68"), 175m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(736), new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Mom-CellPhone", new DateTime(2024, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", null, "Credit" },
                    { new Guid("9c38b71b-f99d-4ad1-993e-de2ad8c3ac85"), 378.27m, "", "OPM1 TREAS 310 (XXCIV SERV)", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(758), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "OPM", new DateTime(2024, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", null, "Credit" },
                    { new Guid("ab72016f-20bd-44ae-af0d-8ce47cf73e19"), -98.51m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(714), null, null, null, "Bill Clark", null, "", "Irregular", null, "Debit" },
                    { new Guid("fda39822-5714-4620-a17f-66f0f0a97889"), -150.47m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(672), new DateTime(2024, 12, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Amazon", new DateTime(2024, 12, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Yearly", null, "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Settings",
                columns: new[] { "Id", "DefaultAccountId", "SearchDayCount" },
                values: new object[] { 1, new Guid("b356926e-041a-479e-b531-daef60b64a23"), 45 });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedOnUTC", "Name" },
                values: new object[] { new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(221), "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "AccountTransactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "BankTransactionText", "ConfirmationNumber", "CreatedOnUTC", "DueDate", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("0bee4645-f293-431b-9e46-7dab7b5529ba"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -500m, 149.11m, "", "", new DateTime(2023, 11, 23, 0, 0, 10, 0, DateTimeKind.Unspecified), null, "Capital One", "", null, new DateTime(2023, 12, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 12, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("2603d6d5-548c-462b-a3de-371f2d502005"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -100m, 661.84m, "", "", new DateTime(2023, 11, 23, 0, 0, 7, 0, DateTimeKind.Unspecified), null, "Alice", "Help Alice Rent / Venmo", null, new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("275b96fb-7a01-456a-ab60-5557dfb28c17"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -70m, 246.49m, "", "", new DateTime(2023, 11, 23, 0, 0, 15, 0, DateTimeKind.Unspecified), null, "Monique / Dexter Grooming", "", null, new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 12, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("560510db-4078-4beb-8922-5d90b1ada9d5"), new Guid("b7ad9496-442a-48a9-85a5-c90abf5d4f6c"), -9.73m, -902.42m, "", "", new DateTime(2023, 12, 23, 0, 0, 1, 0, DateTimeKind.Unspecified), null, "Whataburger", "", null, null, new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("583095f0-59ba-41d7-83a2-c74a6cd4513b"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), 250m, 316.49m, "", "", new DateTime(2023, 11, 23, 0, 0, 14, 0, DateTimeKind.Unspecified), null, "Mom / Xmas+Birthday", "", null, new DateTime(2023, 12, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" },
                    { new Guid("62b73cbc-2a30-40b8-9dfd-ffa9c4b83d47"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), 1998m, 2371.79m, "", "", new DateTime(2023, 12, 22, 0, 0, 20, 0, DateTimeKind.Unspecified), null, "SSDI", "", new Guid("23cbb976-502c-47ff-bd3e-9d2157ff3c7a"), new DateTime(2023, 12, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("95232b4a-b2ae-4d73-87fd-b35fd0a44ac7"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), 175m, 421.49m, "", "", new DateTime(2023, 11, 23, 0, 0, 16, 0, DateTimeKind.Unspecified), null, "Mom / Cell Phone", "", null, new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("a515f501-4885-47c9-8c72-4699b196ea32"), new Guid("b7ad9496-442a-48a9-85a5-c90abf5d4f6c"), -70.89m, -973.31m, "", "", new DateTime(2023, 12, 23, 0, 0, 2, 0, DateTimeKind.Unspecified), null, "SMARTERASP.NET", "", null, null, new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("a8036b9b-e15d-4dd9-bd7e-03b5af0802b2"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -838.07m, 1086.41m, "", "", new DateTime(2023, 11, 23, 0, 0, 2, 0, DateTimeKind.Unspecified), null, "Capital One", "", null, new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("b3b70192-3484-4931-8b1e-eeaabd6dc648"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), 378.27m, 761.84m, "", "", new DateTime(2023, 11, 23, 0, 0, 6, 0, DateTimeKind.Unspecified), null, "OPM", "", new Guid("9c38b71b-f99d-4ad1-993e-de2ad8c3ac85"), new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" },
                    { new Guid("bec1d1f1-8284-479d-9a05-de9b29288cc0"), new Guid("b7ad9496-442a-48a9-85a5-c90abf5d4f6c"), -30.29m, -892.69m, "", "", new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Valve", "", null, null, new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("d5e75935-c427-4e37-b52a-0fda33ffeba0"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), 0.06m, 649.11m, "", "", new DateTime(2023, 11, 23, 0, 0, 9, 0, DateTimeKind.Unspecified), null, "Dividends", "", null, new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" },
                    { new Guid("f49b130f-e256-4b81-82a9-c5a8a0696a31"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -35m, 114.11m, "", "", new DateTime(2023, 11, 23, 0, 0, 11, 0, DateTimeKind.Unspecified), null, "Capital One", "", null, new DateTime(2023, 12, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 12, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" }
                });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "BankTransactionRegEx", "BankTransactionText", "CreatedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyValue", "Name", "NextDueDate", "Notes", "RecurringFrequencyType", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("3e415495-4325-4c7f-8dd1-11ced2caa22d"), -36.81m, "", "TN 888 242 2060 FITNESS YOUR", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(443), new DateTime(2023, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 9, "Fitness Your Way", new DateTime(2024, 2, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("42f7823e-bfc3-4ec6-949e-c7a496b70201"), -2.99m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(336), new DateTime(2023, 1, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Apple iCloud", new DateTime(2024, 2, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("6f6e8fc9-96ea-446b-9b9d-6e53f7540be2"), -16.79m, "", "ALLSTATE INS CO (INS PREM)", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(309), new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Allstate Apartment Insurance", new DateTime(2024, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("81f598fe-bc6c-4380-862c-382b0c90621e"), -83.36m, "", "Transfer", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(522), new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Personal Loan", new DateTime(2024, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("90c5999e-8651-45a3-81d1-8a1f00120ac6"), -12.79m, "", "CA CC GOOGLE.COM GOOGLE*GSUITE", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(470), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Etherpunk", new DateTime(2024, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("b064430a-1899-4508-98a3-e943c2055a4e"), -10.81m, "", "CA 408 536 6000 ADOBE INC.", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(248), new DateTime(2023, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Adobe Photoshop", new DateTime(2024, 2, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("b7b221cb-fe89-4fc3-95a0-4c86ecd1c668"), -80.72m, "", "TX 800 331 0500 ATT*BILL", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(388), new DateTime(2023, 1, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "AT&T", new DateTime(2024, 2, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("c1448d42-2185-4f6c-af78-53ded9ecdab0"), -472.12m, "", "WEBUSDA NFC DPRS (ONLINE PMT)", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(494), new DateTime(2023, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Health Insurance", new DateTime(2024, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("da4a6199-ac5a-499a-ade9-b319b8977894"), -27.92m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(363), new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Apple Services", new DateTime(2024, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("dba4b32c-a3bb-4aad-ba8f-7486ef7ec68c"), -104.00m, "", "WEBVENMO (PAYMENT)", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(547), new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Verizon", new DateTime(2024, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Venmo money to Tim", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("df7362e1-a243-4de8-a011-10201db85543"), -150.00m, "", "WEBWELLS FARGO CARD (CCPYMT)", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(577), new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "WF: Windows", new DateTime(2024, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("ecc1d6de-949c-4e0c-a455-d01de4d920fa"), -67.5m, "", "", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(602), new DateTime(2024, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "WF: A/C", new DateTime(2024, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" },
                    { new Guid("fc40f479-350a-400b-815e-89dbac39d61f"), -719.52m, "", "Transfer", new DateTime(2024, 1, 27, 3, 50, 0, 279, DateTimeKind.Utc).AddTicks(416), new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Explorer", new DateTime(2024, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("7f2b12ea-04d2-4abb-9d24-f9e1e1c8c87f"), "Debit" }
                });

            migrationBuilder.InsertData(
                table: "AccountTransactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "BankTransactionText", "ConfirmationNumber", "CreatedOnUTC", "DueDate", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("499a1f06-0f73-492c-942e-d7578bc5a725"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -83.36m, 2028.48m, "", "", new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Personal Loan", "", new Guid("81f598fe-bc6c-4380-862c-382b0c90621e"), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("7a8bf93b-3d76-4a15-9b98-75063bd64ddd"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -472.12m, 383.57m, "", "", new DateTime(2023, 11, 23, 0, 0, 5, 0, DateTimeKind.Unspecified), null, "Health Insurance", "", new Guid("c1448d42-2185-4f6c-af78-53ded9ecdab0"), new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("8b67b401-fead-4703-9082-1de0b8ce7e4a"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -36.81m, 77.30m, "", "", new DateTime(2023, 11, 23, 0, 0, 12, 0, DateTimeKind.Unspecified), null, "Fitness Your Way", "", new Guid("3e415495-4325-4c7f-8dd1-11ced2caa22d"), new DateTime(2023, 12, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("95c3fb7d-9f6c-4289-b9e9-120cf597b217"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -12.79m, 649.05m, "", "", new DateTime(2023, 11, 23, 0, 0, 8, 0, DateTimeKind.Unspecified), null, "Etherpunk", "", new Guid("90c5999e-8651-45a3-81d1-8a1f00120ac6"), new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("9d6d1436-57ac-4735-8fca-c24589cf17a8"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -80.72m, 1005.69m, "", "", new DateTime(2023, 11, 23, 0, 0, 3, 0, DateTimeKind.Unspecified), null, "AT&T", "", new Guid("b7b221cb-fe89-4fc3-95a0-4c86ecd1c668"), new DateTime(2023, 11, 26, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("b95c5478-1895-4c36-98ae-db4821b3b09b"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -150.00m, 855.69m, "", "", new DateTime(2023, 11, 23, 0, 0, 4, 0, DateTimeKind.Unspecified), null, "WF: Windows", "", new Guid("df7362e1-a243-4de8-a011-10201db85543"), new DateTime(2023, 11, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("cf2053bd-a392-4657-8869-461918cc8795"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -27.92m, 373.79m, "", "", new DateTime(2023, 11, 23, 0, 0, 19, 0, DateTimeKind.Unspecified), null, "Apple Services", "", new Guid("da4a6199-ac5a-499a-ade9-b319b8977894"), null, null, "Debit" },
                    { new Guid("e8a4ef8b-b87b-4717-9aed-be4a61f5dce6"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -16.79m, 404.70m, "", "", new DateTime(2023, 12, 19, 0, 0, 17, 0, DateTimeKind.Unspecified), null, "Allstate Apartment Insurance", "", new Guid("6f6e8fc9-96ea-446b-9b9d-6e53f7540be2"), new DateTime(2023, 12, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("ed5c7d50-9870-4fcb-a90c-172a3397fbb9"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -104.00m, 1924.48m, "", "", new DateTime(2023, 11, 23, 0, 0, 1, 0, DateTimeKind.Unspecified), null, "Verizon", "", new Guid("dba4b32c-a3bb-4aad-ba8f-7486ef7ec68c"), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("efe97f54-3860-4e6c-baf7-8e7e88431948"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -2.99m, 401.71m, "", "", new DateTime(2023, 11, 23, 0, 0, 18, 0, DateTimeKind.Unspecified), null, "Apple iCloud", "", new Guid("42f7823e-bfc3-4ec6-949e-c7a496b70201"), null, null, "Debit" },
                    { new Guid("f204b11f-e940-46e7-8e1e-4e6307a24099"), new Guid("b356926e-041a-479e-b531-daef60b64a23"), -10.81m, 66.49m, "", "", new DateTime(2023, 11, 23, 0, 0, 13, 0, DateTimeKind.Unspecified), null, "Adobe Photoshop", "", new Guid("b064430a-1899-4508-98a3-e943c2055a4e"), new DateTime(2023, 12, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "AccountTransactionId", "CategoryId" },
                values: new object[] { new Guid("b3b70192-3484-4931-8b1e-eeaabd6dc648"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") });

            migrationBuilder.InsertData(
                table: "Link_Category_RecurringTransactions",
                columns: new[] { "CategoryId", "RecurringTransactionId" },
                values: new object[,]
                {
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("3e415495-4325-4c7f-8dd1-11ced2caa22d") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("42f7823e-bfc3-4ec6-949e-c7a496b70201") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("6f6e8fc9-96ea-446b-9b9d-6e53f7540be2") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("81f598fe-bc6c-4380-862c-382b0c90621e") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("90c5999e-8651-45a3-81d1-8a1f00120ac6") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("b064430a-1899-4508-98a3-e943c2055a4e") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("b7b221cb-fe89-4fc3-95a0-4c86ecd1c668") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("c1448d42-2185-4f6c-af78-53ded9ecdab0") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("da4a6199-ac5a-499a-ade9-b319b8977894") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("dba4b32c-a3bb-4aad-ba8f-7486ef7ec68c") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("df7362e1-a243-4de8-a011-10201db85543") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("ecc1d6de-949c-4e0c-a455-d01de4d920fa") },
                    { new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac"), new Guid("fc40f479-350a-400b-815e-89dbac39d61f") }
                });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "AccountTransactionId", "CategoryId" },
                values: new object[,]
                {
                    { new Guid("499a1f06-0f73-492c-942e-d7578bc5a725"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("7a8bf93b-3d76-4a15-9b98-75063bd64ddd"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("8b67b401-fead-4703-9082-1de0b8ce7e4a"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("95c3fb7d-9f6c-4289-b9e9-120cf597b217"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("9d6d1436-57ac-4735-8fca-c24589cf17a8"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("b95c5478-1895-4c36-98ae-db4821b3b09b"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("cf2053bd-a392-4657-8869-461918cc8795"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("e8a4ef8b-b87b-4717-9aed-be4a61f5dce6"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("ed5c7d50-9870-4fcb-a90c-172a3397fbb9"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("efe97f54-3860-4e6c-baf7-8e7e88431948"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") },
                    { new Guid("f204b11f-e940-46e7-8e1e-4e6307a24099"), new Guid("0cb56767-1a25-4c07-ad99-a0b7a449fcac") }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AccountTransactions_AccountId",
                table: "AccountTransactions",
                column: "AccountId");

            migrationBuilder.CreateIndex(
                name: "IX_AccountTransactions_RecurringTransactionId",
                table: "AccountTransactions",
                column: "RecurringTransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Files_AccountTransactionId",
                table: "Files",
                column: "AccountTransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Files_Name",
                table: "Files",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Link_Categories_Transactions_CategoryId",
                table: "Link_Categories_Transactions",
                column: "CategoryId");

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
                name: "AccountTransactions");

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
