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
                name: "Lookup_RecurringTransactionFrequencies",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    Ordinal = table.Column<int>(type: "INTEGER", nullable: false),
                    DisplayString = table.Column<string>(type: "TEXT", nullable: false),
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Lookup_RecurringTransactionFrequencies", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Lookup_RecurringTransactionFrequencies_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Lookup_RecurringTransactionFrequencies_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Lookup_TransactionTypes",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                    Ordinal = table.Column<int>(type: "INTEGER", nullable: false),
                    DisplayString = table.Column<string>(type: "TEXT", nullable: false),
                    DeletedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    DeletedById = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedOnUTC = table.Column<DateTime>(type: "TEXT", nullable: false),
                    CreatedById = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Lookup_TransactionTypes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Lookup_TransactionTypes_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Lookup_TransactionTypes_AspNetUsers_DeletedById",
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
                    FrequencyLookupId = table.Column<Guid>(type: "TEXT", nullable: false),
                    FrequencyValue = table.Column<int>(type: "INTEGER", nullable: true),
                    FrequencyDayOfWeekValue = table.Column<int>(type: "INTEGER", nullable: true),
                    FrequencyDateValue = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionGroupId = table.Column<Guid>(type: "TEXT", nullable: true),
                    TransactionTypeLookupId = table.Column<Guid>(type: "TEXT", nullable: false),
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
                        name: "FK_RecurringTransactions_Lookup_RecurringTransactionFrequencies_FrequencyLookupId",
                        column: x => x.FrequencyLookupId,
                        principalTable: "Lookup_RecurringTransactionFrequencies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RecurringTransactions_Lookup_TransactionTypes_TransactionTypeLookupId",
                        column: x => x.TransactionTypeLookupId,
                        principalTable: "Lookup_TransactionTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
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
                    TransactionPendingUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionClearedUTC = table.Column<DateTime>(type: "TEXT", nullable: true),
                    Balance = table.Column<decimal>(type: "TEXT", precision: 18, scale: 2, nullable: false),
                    Notes = table.Column<string>(type: "TEXT", nullable: false),
                    RecurringTransactionId = table.Column<Guid>(type: "TEXT", nullable: true),
                    TransactionTypeLookupId = table.Column<Guid>(type: "TEXT", nullable: false),
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
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Transactions_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Transactions_Lookup_TransactionTypes_TransactionTypeLookupId",
                        column: x => x.TransactionTypeLookupId,
                        principalTable: "Lookup_TransactionTypes",
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
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "CreatedOn", "Email", "EmailConfirmed", "FirstName", "IsDisabled", "LastName", "LocalTimeZone", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "00000000-0000-0000-0000-000000000000", 0, "290b223e-bc82-495f-b331-a1d79c2fe308", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2608), "", false, "admin", false, "admin", "Central Standard Time", false, null, null, null, null, null, false, "fb572419-4a1d-4ecc-bc9a-8adc9808eea2", false, "Admin" });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedById", "CreatedOnUTC", "CurrentBalance", "DeletedById", "DeletedOnUTC", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[] { new Guid("ca2444db-f971-48b8-b504-e298ec65b400"), "", "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2743), 1987.19m, null, null, 0m, new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2751), "", "Cash", "", -10.81m, 1, 200m });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("27a07080-703f-4de0-a84a-305ce263515a"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2772), null, null, "streaming" },
                    { new Guid("74ab2bc7-3b16-4293-84ba-c3e51c7794d4"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2765), null, null, "fast-food" },
                    { new Guid("a3a44de7-bf38-44ce-93d0-9bd79458fe96"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2766), null, null, "gas" },
                    { new Guid("ac43ead6-51eb-4f2e-b0f3-51c9dd75fb5f"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2768), null, null, "groceries" },
                    { new Guid("cad4a9d1-7411-4716-8bd2-54facaa70507"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2770), null, null, "medications" },
                    { new Guid("e564866a-3e75-4048-b237-d1b892c644f2"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2757), null, null, "bills" }
                });

            migrationBuilder.InsertData(
                table: "Lookup_RecurringTransactionFrequencies",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DisplayString", "Name", "Ordinal" },
                values: new object[,]
                {
                    { new Guid("06ef9451-3322-40f9-baaf-aaee0bede78c"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2911), null, null, "", "Annually", 0 },
                    { new Guid("32565d65-f8d7-4881-95aa-1f3ce8b51691"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2917), null, null, "", "Weekly", 2 },
                    { new Guid("336b615e-c4cc-48c4-af87-f446470fce97"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2923), null, null, "", "Unknown", 6 },
                    { new Guid("538f2c32-ac1f-4afb-b66d-f514c22c8eea"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2916), null, null, "", "Monthly", 1 },
                    { new Guid("74cfdfa6-0c5d-432a-bfb3-26c05deec54f"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2922), null, null, "", "Irregular", 5 },
                    { new Guid("9bfd244a-1834-4cb6-ba4c-5047309c4eff"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2919), null, null, "", "XDays", 3 },
                    { new Guid("cf150960-f18e-42ea-8a5e-e15b7fd0360a"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2921), null, null, "", "XWeekYDayOfWeek", 4 }
                });

            migrationBuilder.InsertData(
                table: "Lookup_TransactionTypes",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DisplayString", "Name", "Ordinal" },
                values: new object[,]
                {
                    { new Guid("1e748af1-dee6-488b-8cac-f6a56f8e9dec"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2859), null, null, "", "Credit", 1 },
                    { new Guid("f794bcb1-0533-4d02-a444-b18c500e0ca7"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(2856), null, null, "", "Debit", 0 }
                });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[] { new Guid("950ffba2-9f47-41fe-ad80-885f085cc5cb"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3034), null, null, "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyLookupId", "FrequencyValue", "Name", "NextDueDate", "Notes", "TransactionGroupId", "TransactionTypeLookupId" },
                values: new object[,]
                {
                    { new Guid("ba1e1518-aa64-47fe-87de-0c0ca6eb70e6"), -16.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3109), null, null, null, null, new Guid("538f2c32-ac1f-4afb-b66d-f514c22c8eea"), 18, "Allstate Apartment Insurance", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("950ffba2-9f47-41fe-ad80-885f085cc5cb"), new Guid("f794bcb1-0533-4d02-a444-b18c500e0ca7") },
                    { new Guid("c014e3d0-525b-42c1-b0c4-47421aa0ea76"), 150m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3148), null, null, null, null, new Guid("538f2c32-ac1f-4afb-b66d-f514c22c8eea"), 18, "Test", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, new Guid("1e748af1-dee6-488b-8cac-f6a56f8e9dec") },
                    { new Guid("cd3ad128-5f8f-40f0-a3a8-9b65bbb1f986"), 1343.72m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3164), null, null, null, 3, new Guid("cf150960-f18e-42ea-8a5e-e15b7fd0360a"), 4, "Payday", new DateTime(2023, 11, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, new Guid("1e748af1-dee6-488b-8cac-f6a56f8e9dec") },
                    { new Guid("f491998f-1e7b-49fd-808a-eb32d21df471"), -10.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3057), null, null, null, null, new Guid("538f2c32-ac1f-4afb-b66d-f514c22c8eea"), 15, "Adobe Photoshop", new DateTime(2024, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("950ffba2-9f47-41fe-ad80-885f085cc5cb"), new Guid("f794bcb1-0533-4d02-a444-b18c500e0ca7") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionTypeLookupId" },
                values: new object[] { new Guid("ca3f73bf-51bd-46e5-9fd0-613a36955aa6"), new Guid("ca2444db-f971-48b8-b504-e298ec65b400"), 1998m, 1998m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3178), null, null, "payday", "", null, new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new Guid("1e748af1-dee6-488b-8cac-f6a56f8e9dec") });

            migrationBuilder.InsertData(
                table: "Link_Category_RecurringTransactions",
                columns: new[] { "CategoryId", "RecurringTransactionId" },
                values: new object[,]
                {
                    { new Guid("e564866a-3e75-4048-b237-d1b892c644f2"), new Guid("ba1e1518-aa64-47fe-87de-0c0ca6eb70e6") },
                    { new Guid("e564866a-3e75-4048-b237-d1b892c644f2"), new Guid("f491998f-1e7b-49fd-808a-eb32d21df471") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionTypeLookupId" },
                values: new object[] { new Guid("46c6b03e-fe89-41d9-8e03-3431367089c6"), new Guid("ca2444db-f971-48b8-b504-e298ec65b400"), -10.81m, 1987.19m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 15, 4, 48, 57, 325, DateTimeKind.Utc).AddTicks(3231), null, null, "Adobe Photoshop", "", new Guid("f491998f-1e7b-49fd-808a-eb32d21df471"), null, null, new Guid("f794bcb1-0533-4d02-a444-b18c500e0ca7") });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[] { new Guid("e564866a-3e75-4048-b237-d1b892c644f2"), new Guid("46c6b03e-fe89-41d9-8e03-3431367089c6") });

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
                name: "IX_Link_Categories_Transactions_TransactionId",
                table: "Link_Categories_Transactions",
                column: "TransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Link_Category_RecurringTransactions_RecurringTransactionId",
                table: "Link_Category_RecurringTransactions",
                column: "RecurringTransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Lookup_RecurringTransactionFrequencies_CreatedById",
                table: "Lookup_RecurringTransactionFrequencies",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Lookup_RecurringTransactionFrequencies_DeletedById",
                table: "Lookup_RecurringTransactionFrequencies",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Lookup_RecurringTransactionFrequencies_Name",
                table: "Lookup_RecurringTransactionFrequencies",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Lookup_TransactionTypes_CreatedById",
                table: "Lookup_TransactionTypes",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Lookup_TransactionTypes_DeletedById",
                table: "Lookup_TransactionTypes",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Lookup_TransactionTypes_Name",
                table: "Lookup_TransactionTypes",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_CreatedById",
                table: "RecurringTransactions",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_DeletedById",
                table: "RecurringTransactions",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_FrequencyLookupId",
                table: "RecurringTransactions",
                column: "FrequencyLookupId");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_TransactionGroupId",
                table: "RecurringTransactions",
                column: "TransactionGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTransactions_TransactionTypeLookupId",
                table: "RecurringTransactions",
                column: "TransactionTypeLookupId");

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

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_TransactionTypeLookupId",
                table: "Transactions",
                column: "TransactionTypeLookupId");
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
                name: "Link_Categories_Transactions");

            migrationBuilder.DropTable(
                name: "Link_Category_RecurringTransactions");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "Transactions");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropTable(
                name: "Accounts");

            migrationBuilder.DropTable(
                name: "RecurringTransactions");

            migrationBuilder.DropTable(
                name: "Lookup_RecurringTransactionFrequencies");

            migrationBuilder.DropTable(
                name: "Lookup_TransactionTypes");

            migrationBuilder.DropTable(
                name: "TransactionGroups");

            migrationBuilder.DropTable(
                name: "AspNetUsers");
        }
    }
}
