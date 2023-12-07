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
                values: new object[] { "00000000-0000-0000-0000-000000000000", 0, "d635eae7-18d8-479e-a5f6-bbd73640645c", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(7959), "", false, "admin", false, "admin", "Central Standard Time", false, null, null, null, null, null, false, "8bf15fd6-51c7-43ad-b12e-b848b562e2ec", false, "Admin" });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedById", "CreatedOnUTC", "CurrentBalance", "DeletedById", "DeletedOnUTC", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[] { new Guid("d7d75c03-e873-4f05-b5d3-fbe35be4f4a8"), "", "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8128), 1987.19m, null, null, 0m, new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8134), "", "Cash", "", -10.81m, 1, 200m });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("078d95ef-4465-41bb-b6c6-9d184d51ef3a"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8156), null, null, "medications" },
                    { new Guid("0ced9ac4-6b55-42c1-ae7f-303b026cfd45"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8158), null, null, "streaming" },
                    { new Guid("291eee07-9aca-4257-a567-3844c39041dc"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8154), null, null, "groceries" },
                    { new Guid("5a6c2d2e-baab-4c64-ae85-c7e318761613"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8148), null, null, "bills" },
                    { new Guid("b6fc9263-d9fd-40bc-9391-f3b603f7f3c3"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8152), null, null, "gas" },
                    { new Guid("c896dcc7-ea19-4777-810c-35306165138b"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8150), null, null, "fast-food" }
                });

            migrationBuilder.InsertData(
                table: "Lookup_RecurringTransactionFrequencies",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DisplayString", "Name", "Ordinal" },
                values: new object[,]
                {
                    { new Guid("415d159b-0ee5-4c3d-a3c4-1f23eda20ef1"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8307), null, null, "", "Monthly", 1 },
                    { new Guid("56443260-6d7e-490a-934d-0b38bbafa1ab"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8305), null, null, "", "Annually", 0 },
                    { new Guid("948e156e-cae5-436d-9e6e-76f22cc24045"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8311), null, null, "", "XDays", 3 },
                    { new Guid("9b05d0fb-08d4-4fb7-ad6b-a781bd44b30b"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8312), null, null, "", "XWeekYDayOfWeek", 4 },
                    { new Guid("9db655f1-5725-4aa9-b1f3-bbeabe5c662d"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8309), null, null, "", "Weekly", 2 },
                    { new Guid("a7352980-7451-4003-98b7-49672bd5c22c"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8313), null, null, "", "Irregular", 5 },
                    { new Guid("a7b25bc7-bc16-41b0-9181-6847af74a835"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8315), null, null, "", "Unknown", 6 }
                });

            migrationBuilder.InsertData(
                table: "Lookup_TransactionTypes",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DisplayString", "Name", "Ordinal" },
                values: new object[,]
                {
                    { new Guid("9a11cf23-fc72-43a6-a84c-e7b6951bf139"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8269), null, null, "", "Credit", 1 },
                    { new Guid("cddf9538-4dc8-4950-bcb5-4aa80d0f52c1"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8265), null, null, "", "Debit", 0 }
                });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[] { new Guid("cc8e4562-7234-4b74-8f0f-ffa45fde9c0b"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8474), null, null, "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyLookupId", "FrequencyValue", "Name", "NextDueDate", "Notes", "TransactionGroupId", "TransactionTypeLookupId" },
                values: new object[,]
                {
                    { new Guid("09893aa6-90e1-4949-8ead-10fa2da1ad55"), 150m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8614), null, null, null, null, new Guid("415d159b-0ee5-4c3d-a3c4-1f23eda20ef1"), 18, "Test", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, new Guid("9a11cf23-fc72-43a6-a84c-e7b6951bf139") },
                    { new Guid("11b74f76-8047-451e-9cc6-8067951ca2ae"), -10.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8505), null, null, null, null, new Guid("415d159b-0ee5-4c3d-a3c4-1f23eda20ef1"), 15, "Adobe Photoshop", new DateTime(2024, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("cc8e4562-7234-4b74-8f0f-ffa45fde9c0b"), new Guid("cddf9538-4dc8-4950-bcb5-4aa80d0f52c1") },
                    { new Guid("13eccc08-d856-4bbe-9c15-5f1ca9889c45"), 1343.72m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8632), null, null, null, 3, new Guid("9b05d0fb-08d4-4fb7-ad6b-a781bd44b30b"), 4, "Payday", new DateTime(2023, 11, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "", null, new Guid("9a11cf23-fc72-43a6-a84c-e7b6951bf139") },
                    { new Guid("c6580499-9953-4883-9c44-8eacd73459b5"), -16.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8566), null, null, null, null, new Guid("415d159b-0ee5-4c3d-a3c4-1f23eda20ef1"), 18, "Allstate Apartment Insurance", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", new Guid("cc8e4562-7234-4b74-8f0f-ffa45fde9c0b"), new Guid("cddf9538-4dc8-4950-bcb5-4aa80d0f52c1") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionTypeLookupId" },
                values: new object[] { new Guid("fa71a04c-8e7e-4e60-b7c7-d25edf0df597"), new Guid("d7d75c03-e873-4f05-b5d3-fbe35be4f4a8"), 1998m, 1998m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8655), null, null, "payday", "", null, new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new Guid("9a11cf23-fc72-43a6-a84c-e7b6951bf139") });

            migrationBuilder.InsertData(
                table: "Link_Category_RecurringTransactions",
                columns: new[] { "CategoryId", "RecurringTransactionId" },
                values: new object[,]
                {
                    { new Guid("5a6c2d2e-baab-4c64-ae85-c7e318761613"), new Guid("11b74f76-8047-451e-9cc6-8067951ca2ae") },
                    { new Guid("5a6c2d2e-baab-4c64-ae85-c7e318761613"), new Guid("c6580499-9953-4883-9c44-8eacd73459b5") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionTypeLookupId" },
                values: new object[] { new Guid("70989e28-cf1b-47f5-8d06-b46200a937b2"), new Guid("d7d75c03-e873-4f05-b5d3-fbe35be4f4a8"), -10.81m, 1987.19m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 7, 16, 14, 24, 464, DateTimeKind.Utc).AddTicks(8693), null, null, "Adobe Photoshop", "", new Guid("11b74f76-8047-451e-9cc6-8067951ca2ae"), null, null, new Guid("cddf9538-4dc8-4950-bcb5-4aa80d0f52c1") });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[] { new Guid("5a6c2d2e-baab-4c64-ae85-c7e318761613"), new Guid("70989e28-cf1b-47f5-8d06-b46200a937b2") });

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
