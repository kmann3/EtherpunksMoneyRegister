using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace MoneyRegister.Data.Migrations
{
    /// <inheritdoc />
    public partial class _000init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<string>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<string>(type: "TEXT", nullable: false),
                    FirstName = table.Column<string>(type: "TEXT", nullable: false),
                    IsDisabled = table.Column<bool>(type: "INTEGER", nullable: false),
                    LastName = table.Column<string>(type: "TEXT", nullable: false),
                    LocalTimeZone = table.Column<string>(type: "TEXT", nullable: false),
                    CreatedOn = table.Column<DateTime>(type: "TEXT", nullable: false),
                    UserName = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "INTEGER", nullable: false),
                    PasswordHash = table.Column<string>(type: "TEXT", nullable: true),
                    SecurityStamp = table.Column<string>(type: "TEXT", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "TEXT", nullable: true),
                    PhoneNumber = table.Column<string>(type: "TEXT", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "INTEGER", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "INTEGER", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "TEXT", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "INTEGER", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    RoleId = table.Column<string>(type: "TEXT", nullable: false),
                    ClaimType = table.Column<string>(type: "TEXT", nullable: true),
                    ClaimValue = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

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
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Accounts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Accounts_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Accounts_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    UserId = table.Column<string>(type: "TEXT", nullable: false),
                    ClaimType = table.Column<string>(type: "TEXT", nullable: true),
                    ClaimValue = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "TEXT", nullable: false),
                    ProviderKey = table.Column<string>(type: "TEXT", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "TEXT", nullable: true),
                    UserId = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "TEXT", nullable: false),
                    RoleId = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "TEXT", nullable: false),
                    LoginProvider = table.Column<string>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", nullable: false),
                    Value = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Categories_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Categories_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "TransactionGroups",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TransactionGroups", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TransactionGroups_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TransactionGroups_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
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
                    Frequency = table.Column<int>(type: "INTEGER", nullable: false),
                    FrequencyValue = table.Column<int>(type: "INTEGER", nullable: true),
                    DayOfWeekValue = table.Column<int>(type: "INTEGER", nullable: true),
                    TransactionGroupId = table.Column<Guid>(type: "TEXT", nullable: true),
                    TransactionType = table.Column<int>(type: "INTEGER", nullable: false),
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecurringTransactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RecurringTransactions_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RecurringTransactions_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
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
                    CategoriesId = table.Column<Guid>(type: "TEXT", nullable: false),
                    RecurringTransactionsId = table.Column<Guid>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Link_Category_RecurringTransactions", x => new { x.CategoriesId, x.RecurringTransactionsId });
                    table.ForeignKey(
                        name: "FK_Link_Category_RecurringTransactions_Categories_CategoriesId",
                        column: x => x.CategoriesId,
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Link_Category_RecurringTransactions_RecurringTransactions_RecurringTransactionsId",
                        column: x => x.RecurringTransactionsId,
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
                    TransactionPendingUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionClearedUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    Balance = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    RecurringTransactionId = table.Column<Guid>(type: "TEXT", nullable: true),
                    TransactionType = table.Column<int>(type: "INTEGER", nullable: false),
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
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
                        name: "FK_Transactions_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Transactions_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
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
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Files", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Files_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Files_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Files_Transactions_TransactionId",
                        column: x => x.TransactionId,
                        principalTable: "Transactions",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Link_Category_Transaction",
                columns: table => new
                {
                    CategoriesId = table.Column<Guid>(type: "TEXT", nullable: false),
                    TransactionsId = table.Column<Guid>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Link_Category_Transaction", x => new { x.CategoriesId, x.TransactionsId });
                    table.ForeignKey(
                        name: "FK_Link_Category_Transaction_Categories_CategoriesId",
                        column: x => x.CategoriesId,
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Link_Category_Transaction_Transactions_TransactionsId",
                        column: x => x.TransactionsId,
                        principalTable: "Transactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "CreatedOn", "Email", "EmailConfirmed", "FirstName", "IsDisabled", "LastName", "LocalTimeZone", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "00000000-0000-0000-0000-000000000000", 0, "59dfaf52-0009-49b2-8d4c-db2d025b8608", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9121), "", false, "admin", false, "admin", "Central Standard Time", false, null, null, null, null, null, false, "713d71f7-51f0-4dd7-8ecc-cb596254e9f4", false, "Admin" });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedById", "CreatedOnUTC", "CurrentBalance", "DeletedById", "DeletedOnUTC", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[] { new Guid("0af5ab9b-c1fb-4255-bc49-9b7c23014a78"), "", "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9362), 1987.19m, null, null, 0.0m, new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9369), "", "Cash", "", -10.81m, 1, 200.0m });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("18cbb4e6-c061-4c99-ba1c-48aa58796a3c"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9380), null, null, "gas" },
                    { new Guid("27e5f753-ad87-4e3b-891d-b8b8b79e8045"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9385), null, null, "medications" },
                    { new Guid("34940e40-e15f-4c60-82ec-e2f17aac7d04"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9381), null, null, "groceries" },
                    { new Guid("5aa2d257-47c6-4099-9b9b-ddb92e697ef0"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9378), null, null, "fast-food" },
                    { new Guid("b7e07c97-b19a-4eb7-a21c-f7f04752f283"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9386), null, null, "streaming" },
                    { new Guid("f8cd9912-25ee-4a10-bb9f-3e686d55e6b7"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9377), null, null, "bills" }
                });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DayOfWeekValue", "DeletedById", "DeletedOnUTC", "Frequency", "FrequencyValue", "Name", "NextDueDate", "Notes", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("53066614-6c99-4a75-a8f7-8060626bbeca"), -13.0m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9693), null, null, null, 3, null, "Etherpunk DNS", new DateTime(2024, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, 1 },
                    { new Guid("54aca43c-77b8-447c-99b5-f2a9cbb1998a"), 150.0m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9720), null, null, null, 0, null, "Mom / Cellphone", new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, 0 },
                    { new Guid("699ed7e7-3829-48df-98fc-7c6d13abd241"), 378.27m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9745), null, null, null, 0, null, "OPM", new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, 0 },
                    { new Guid("830af3fd-ad62-43f5-9d23-daa961a7919a"), 1998.0m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9732), 3, null, null, 2, 4, "SSDI", new DateTime(2023, 12, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, 0 },
                    { new Guid("d542b67c-11e8-4880-a8d8-6cc9c613fcdc"), -59.4m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9708), null, null, null, 3, null, "Etherpunk Webhosting", new DateTime(2024, 1, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, 1 }
                });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[] { new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9473), null, null, "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DayOfWeekValue", "DeletedById", "DeletedOnUTC", "Frequency", "FrequencyValue", "Name", "NextDueDate", "Notes", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("09c4a9ac-78dd-4aec-9805-c219daa630fc"), -2.99m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9537), null, null, null, 0, null, "Apple iCloud", new DateTime(2023, 12, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("4e1cca60-3ecb-41d1-9265-df24a6d1a5ce"), -472.12m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9639), null, null, null, 0, null, "Health Insurance", new DateTime(2023, 12, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("58e9475b-e553-42aa-84c8-0f8bd0fd8300"), -719.52m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9579), null, null, null, 0, null, "Loan - Ford Explorer", new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("6256ea4d-6822-4445-8fe7-e476f5dfcf44"), -10.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9498), null, null, null, 0, null, "Adobe Photoshop", new DateTime(2023, 12, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("a5644261-6862-4e72-94af-677acd7a377d"), -36.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9613), null, null, null, 0, null, "Fitness Your Way", new DateTime(2023, 12, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("bba98b29-af98-4cbf-963b-1d6d1bcbe2e6"), -83.36m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9653), null, null, null, 0, null, "Loan - DebtCon/Vacation", new DateTime(2023, 12, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("bbc47043-cc36-4159-a722-e8ec4deba673"), -12.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9626), null, null, null, 0, null, "Google / Etherpunk Email", new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("c40f3ad9-2c10-4236-9971-2570ea24df55"), -104.0m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9667), null, null, null, 0, null, "Verizon / Cellphone", new DateTime(2023, 12, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("cf32f842-89ac-43a6-a860-929c11ca07f2"), -16.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9523), null, null, null, 0, null, "Allstate Apartment Insurance", new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("dc85f682-c4e5-425f-b603-9998e4f4acea"), -24.67m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9551), null, null, null, 0, null, "Apple Services", new DateTime(2023, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("ea3d515f-4c33-4519-811e-fb27c6d4a8f8"), -80.72m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9564), null, null, null, 0, null, "ATT Internet", new DateTime(2023, 12, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 },
                    { new Guid("f1d9797c-baf0-47d0-be4a-8d83b3db9f88"), -150.0m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9681), null, null, null, 0, null, "Windows", new DateTime(2023, 12, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("da0c6b64-6975-4c0e-89ad-f096466ff3a4"), 1 }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("f8dc1389-d1ad-4b29-8f75-cdf8ef183374"), new Guid("0af5ab9b-c1fb-4255-bc49-9b7c23014a78"), 1998.0m, 1998.0m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9756), null, null, "SSDI", "", null, new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), 0 },
                    { new Guid("18ab2619-f85c-4038-98a7-2d55f4a4db9c"), new Guid("0af5ab9b-c1fb-4255-bc49-9b7c23014a78"), -10.81m, 1987.19m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 19, 10, 12, 38, 619, DateTimeKind.Unspecified).AddTicks(9783), null, null, "Adobe Photoshop", "", new Guid("6256ea4d-6822-4445-8fe7-e476f5dfcf44"), null, null, 1 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Accounts_CreatedById",
                table: "Accounts",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Accounts_DeletedById",
                table: "Accounts",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Categories_CreatedById",
                table: "Categories",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Categories_DeletedById",
                table: "Categories",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Files_CreatedById",
                table: "Files",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Files_DeletedById",
                table: "Files",
                column: "DeletedById");

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
                name: "IX_Link_Category_RecurringTransactions_RecurringTransactionsId",
                table: "Link_Category_RecurringTransactions",
                column: "RecurringTransactionsId");

            migrationBuilder.CreateIndex(
                name: "IX_Link_Category_Transaction_TransactionsId",
                table: "Link_Category_Transaction",
                column: "TransactionsId");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_CreatedById",
                table: "RecurringTransactions",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_DeletedById",
                table: "RecurringTransactions",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_TransactionGroupId",
                table: "RecurringTransactions",
                column: "TransactionGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_TransactionGroups_CreatedById",
                table: "TransactionGroups",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_TransactionGroups_DeletedById",
                table: "TransactionGroups",
                column: "DeletedById");

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
                name: "IX_Transactions_CreatedById",
                table: "Transactions",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_DeletedById",
                table: "Transactions",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_RecurringTransactionId",
                table: "Transactions",
                column: "RecurringTransactionId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "Files");

            migrationBuilder.DropTable(
                name: "Link_Category_RecurringTransactions");

            migrationBuilder.DropTable(
                name: "Link_Category_Transaction");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropTable(
                name: "Transactions");

            migrationBuilder.DropTable(
                name: "Accounts");

            migrationBuilder.DropTable(
                name: "RecurringTransactions");

            migrationBuilder.DropTable(
                name: "TransactionGroups");

            migrationBuilder.DropTable(
                name: "AspNetUsers");
        }
    }
}
