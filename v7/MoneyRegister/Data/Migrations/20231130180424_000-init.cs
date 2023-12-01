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
                    DayOfWeekValue = table.Column<int>(type: "INTEGER", nullable: true),
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
                values: new object[] { "00000000-0000-0000-0000-000000000000", 0, "1a8e5591-1f72-4fae-a3c0-8b67d330195f", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8290), "", false, "admin", false, "admin", "Central Standard Time", false, null, null, null, null, null, false, "791d2292-1222-4119-8cd9-32035ef83e5b", false, "Admin" });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedById", "CreatedOnUTC", "CurrentBalance", "DeletedById", "DeletedOnUTC", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[] { new Guid("b1086ec1-54e4-4e6b-b4df-bd899173c5b5"), "", "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8444), 1987.19m, null, null, 0m, new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8450), "", "Cash", "", -10.81m, 1, 200m });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("28969564-5fac-43cb-9312-23eb6687c1ad"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8460), null, null, "fast-food" },
                    { new Guid("3af5cbb9-db6a-4cb3-8b26-2c448b61a519"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8465), null, null, "medications" },
                    { new Guid("62a36dc5-88e5-414c-81b3-cc9d65730bad"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8462), null, null, "gas" },
                    { new Guid("97f52edb-840e-4b04-a865-c17d0a950faa"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8467), null, null, "streaming" },
                    { new Guid("a8909893-d95b-429b-aff8-d20588a4591d"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8464), null, null, "groceries" },
                    { new Guid("dbd98324-9c2d-416d-aab5-0ed0a7239795"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8458), null, null, "bills" }
                });

            migrationBuilder.InsertData(
                table: "Lookup_RecurringTransactionFrequencies",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DisplayString", "Name", "Ordinal" },
                values: new object[,]
                {
                    { new Guid("1d171f3f-9062-4c69-9d66-772aca93881b"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8619), null, null, "", "Irregular", 5 },
                    { new Guid("4794b272-8abc-4641-8329-279e83f0c8f5"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8614), null, null, "", "Weekly", 2 },
                    { new Guid("72319dd2-d12f-43d1-ae09-b919a382e790"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8610), null, null, "", "Annually", 0 },
                    { new Guid("a2097617-b0d5-40e9-88cb-09b5d6e2db1a"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8621), null, null, "", "Unknown", 6 },
                    { new Guid("d3d285d5-d6d6-46a8-a36b-b65db557859a"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8616), null, null, "", "XDays", 3 },
                    { new Guid("d9c1d516-26bf-4f00-9e18-8c9b8935082c"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8618), null, null, "", "XWeekYDayOfWeek", 4 },
                    { new Guid("e8555454-3b55-47b0-984a-0702dd6b5092"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8612), null, null, "", "Monthly", 1 }
                });

            migrationBuilder.InsertData(
                table: "Lookup_TransactionTypes",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DisplayString", "Name", "Ordinal" },
                values: new object[,]
                {
                    { new Guid("7d755244-fd1a-43e9-a8bd-475d31be1682"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8573), null, null, "", "Debit", 0 },
                    { new Guid("bfd06384-56e9-4921-b30f-01c5f4e354d3"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8578), null, null, "", "Credit", 1 }
                });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[] { new Guid("c8f007a0-ad64-41f5-b6a3-1bac782c2390"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8721), null, null, "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DayOfWeekValue", "DeletedById", "DeletedOnUTC", "FrequencyDateValue", "FrequencyLookupId", "FrequencyValue", "Name", "NextDueDate", "Notes", "TransactionGroupId", "TransactionTypeLookupId" },
                values: new object[,]
                {
                    { new Guid("1cb8f9f3-2c60-4ba8-b666-1fb043e3c791"), -10.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8745), null, null, null, null, new Guid("e8555454-3b55-47b0-984a-0702dd6b5092"), 15, "Adobe Photoshop", new DateTime(2023, 12, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("c8f007a0-ad64-41f5-b6a3-1bac782c2390"), new Guid("7d755244-fd1a-43e9-a8bd-475d31be1682") },
                    { new Guid("5f8cc0c4-c062-4fe7-8292-a7b604d99265"), 150m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8884), null, null, null, null, new Guid("e8555454-3b55-47b0-984a-0702dd6b5092"), 18, "Test", new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, new Guid("bfd06384-56e9-4921-b30f-01c5f4e354d3") },
                    { new Guid("80d96627-438c-4062-aaf8-deb6ef11731a"), 1343.72m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8901), 3, null, null, null, new Guid("d9c1d516-26bf-4f00-9e18-8c9b8935082c"), 4, "Payday", new DateTime(2023, 12, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, new Guid("bfd06384-56e9-4921-b30f-01c5f4e354d3") },
                    { new Guid("e46b3b2a-9905-45a5-970b-8dc86b436833"), -16.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8806), null, null, null, null, new Guid("e8555454-3b55-47b0-984a-0702dd6b5092"), 18, "Allstate Apartment Insurance", new DateTime(2023, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("c8f007a0-ad64-41f5-b6a3-1bac782c2390"), new Guid("7d755244-fd1a-43e9-a8bd-475d31be1682") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionTypeLookupId" },
                values: new object[] { new Guid("318a2889-1a57-4473-af5c-1680ae8bce1e"), new Guid("b1086ec1-54e4-4e6b-b4df-bd899173c5b5"), 1998m, 1998m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8923), null, null, "payday", "", null, new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new Guid("bfd06384-56e9-4921-b30f-01c5f4e354d3") });

            migrationBuilder.InsertData(
                table: "Link_Category_RecurringTransactions",
                columns: new[] { "CategoryId", "RecurringTransactionId" },
                values: new object[,]
                {
                    { new Guid("dbd98324-9c2d-416d-aab5-0ed0a7239795"), new Guid("1cb8f9f3-2c60-4ba8-b666-1fb043e3c791") },
                    { new Guid("dbd98324-9c2d-416d-aab5-0ed0a7239795"), new Guid("e46b3b2a-9905-45a5-970b-8dc86b436833") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionTypeLookupId" },
                values: new object[] { new Guid("a86f0a76-1908-4535-b89f-08373c8f2d9f"), new Guid("b1086ec1-54e4-4e6b-b4df-bd899173c5b5"), -10.81m, 1987.19m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 30, 18, 4, 23, 763, DateTimeKind.Utc).AddTicks(8951), null, null, "Adobe Photoshop", "", new Guid("1cb8f9f3-2c60-4ba8-b666-1fb043e3c791"), null, null, new Guid("7d755244-fd1a-43e9-a8bd-475d31be1682") });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[] { new Guid("dbd98324-9c2d-416d-aab5-0ed0a7239795"), new Guid("a86f0a76-1908-4535-b89f-08373c8f2d9f") });

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
