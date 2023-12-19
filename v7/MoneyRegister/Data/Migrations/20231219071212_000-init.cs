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
                    RecurringFrequencyType = table.Column<string>(type: "TEXT", nullable: false),
                    FrequencyValue = table.Column<int>(type: "INTEGER", nullable: true),
                    FrequencyDayOfWeekValue = table.Column<int>(type: "INTEGER", nullable: true),
                    FrequencyDateValue = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionGroupId = table.Column<Guid>(type: "TEXT", nullable: true),
                    TransactionType = table.Column<string>(type: "TEXT", nullable: false),
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
                    DueDate = table.Column<DateTime>(type: "TEXT", nullable: true),
                    TransactionType = table.Column<string>(type: "TEXT", nullable: false),
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
                values: new object[] { "00000000-0000-0000-0000-000000000000", 0, "0dfdf5ab-a742-42c5-9845-8c96457085e6", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(788), "", false, "admin", false, "admin", "Central Standard Time", false, null, null, null, null, null, false, "9f47ad42-24a1-4df9-b69f-6bb244973e8d", false, "Admin" });

            migrationBuilder.InsertData(
                table: "Accounts",
                columns: new[] { "Id", "AccountNumber", "CreatedById", "CreatedOnUTC", "CurrentBalance", "DeletedById", "DeletedOnUTC", "InterestRate", "LastBalancedUTC", "LoginUrl", "Name", "Notes", "OutstandingBalance", "OutstandingItemCount", "StartingBalance" },
                values: new object[] { new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), "", "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(984), 761.84m, null, null, 0m, new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(992), "", "Neches FCU", "", 0m, 0, 2111.84m });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[,]
                {
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1000), null, null, "bills" },
                    { new Guid("39df5472-ef82-4a03-b1a9-ccfbcf25d8c5"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1019), null, null, "groceries" },
                    { new Guid("4ab6d448-4179-43be-86bd-4cf05e26d491"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1005), null, null, "gas" },
                    { new Guid("9cd0394b-f66d-4dea-8eb2-2e41b33a049a"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1021), null, null, "medications" },
                    { new Guid("c8ea5f23-0e77-4332-a9d8-5204c94ec45b"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1023), null, null, "streaming" },
                    { new Guid("cf625eba-da02-4c9d-aff9-09ac8d518336"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1003), null, null, "fast-food" }
                });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyValue", "Name", "NextDueDate", "Notes", "RecurringFrequencyType", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("6dc2019f-a6f7-45ae-b8df-a440fb5ae116"), 378.27m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1599), null, null, null, null, 1, "OPM", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", null, "Credit" },
                    { new Guid("a2c6bd28-f491-4433-8fab-5304ce375d83"), 175m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1574), null, null, new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Mom-CellPhone", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", null, "Credit" },
                    { new Guid("cb726dbd-1ec4-4755-8e4a-5e5556ecf631"), 1998m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1591), null, null, null, 3, 4, "Payday", new DateTime(2023, 12, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "XWeekOnYDayOfWeek", null, "Credit" }
                });

            migrationBuilder.InsertData(
                table: "TransactionGroups",
                columns: new[] { "Id", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "Name" },
                values: new object[] { new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1128), null, null, "All Regular Bills" });

            migrationBuilder.InsertData(
                table: "RecurringTransactions",
                columns: new[] { "Id", "Amount", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "FrequencyDateValue", "FrequencyDayOfWeekValue", "FrequencyValue", "Name", "NextDueDate", "Notes", "RecurringFrequencyType", "TransactionGroupId", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("19f70248-afcb-41c7-b7b9-b967d5b3344f"), -12.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1413), null, null, new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Etherpunk", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("68dd3256-8d7b-458e-be17-ffc052273299"), -472.12m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1439), null, null, new DateTime(2023, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Health Insurance", new DateTime(2024, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("6fa0e5e2-da85-46e7-87c5-209fe1d9147d"), -2.99m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1269), null, null, new DateTime(2023, 1, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Apple iCloud", new DateTime(2024, 1, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("87261a0a-b9ba-43ad-bc78-c99ae0f6c992"), -27.92m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1297), null, null, new DateTime(2023, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Apple Services", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("8a3d9a08-6890-4381-84c4-7690dbdd3533"), -36.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1384), null, null, new DateTime(2023, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 9, "Fitness Your Way", new DateTime(2024, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("99357fe4-d5ca-49a8-a554-5152e1fe3d8c"), -83.36m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1482), null, null, new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Personal Loan", new DateTime(2024, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("a3e7d0fe-d55f-47b3-b0d6-32b2f0253e83"), -16.79m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1239), null, null, new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Allstate Apartment Insurance", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("d8245289-7405-4cc0-8e42-2fe4d5114d3b"), -104.00m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1511), null, null, new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Verizon", new DateTime(2024, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("d9b44eb1-9677-40a8-9b9f-d616ba560dc9"), -719.52m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1356), null, null, new DateTime(2023, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Explorer", new DateTime(2024, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("db726de5-e85c-4988-9208-d2850aec99a4"), -10.81m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1183), null, null, new DateTime(2023, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Adobe Photoshop", new DateTime(2024, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("ebcbc1c2-994d-4461-8f93-c2f0da45c871"), -150.00m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1538), null, null, new DateTime(2023, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "WF: Windows", new DateTime(2024, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" },
                    { new Guid("f0016241-6925-4b44-8f39-eb0c6f0c841a"), -80.72m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 12, 19, 7, 12, 12, 15, DateTimeKind.Utc).AddTicks(1326), null, null, new DateTime(2023, 1, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "AT&T", new DateTime(2024, 1, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "", "Monthly", new Guid("aff442f2-bf90-4697-b3e9-15e3d26b9c20"), "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DueDate", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("2dd023f6-ec60-4ced-980b-b634b2f2ce64"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), -838.07m, 1086.41m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "Capital One", "", null, new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Debit" },
                    { new Guid("843a4dc2-659a-402f-8535-a960476a1de8"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), 378.27m, 761.84m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "OPM", "", new Guid("6dc2019f-a6f7-45ae-b8df-a440fb5ae116"), new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit" }
                });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[] { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("843a4dc2-659a-402f-8535-a960476a1de8") });

            migrationBuilder.InsertData(
                table: "Link_Category_RecurringTransactions",
                columns: new[] { "CategoryId", "RecurringTransactionId" },
                values: new object[,]
                {
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("19f70248-afcb-41c7-b7b9-b967d5b3344f") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("68dd3256-8d7b-458e-be17-ffc052273299") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("6fa0e5e2-da85-46e7-87c5-209fe1d9147d") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("87261a0a-b9ba-43ad-bc78-c99ae0f6c992") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("8a3d9a08-6890-4381-84c4-7690dbdd3533") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("99357fe4-d5ca-49a8-a554-5152e1fe3d8c") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("a3e7d0fe-d55f-47b3-b0d6-32b2f0253e83") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("d8245289-7405-4cc0-8e42-2fe4d5114d3b") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("d9b44eb1-9677-40a8-9b9f-d616ba560dc9") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("db726de5-e85c-4988-9208-d2850aec99a4") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("ebcbc1c2-994d-4461-8f93-c2f0da45c871") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("f0016241-6925-4b44-8f39-eb0c6f0c841a") }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "Id", "AccountId", "Amount", "Balance", "CreatedById", "CreatedOnUTC", "DeletedById", "DeletedOnUTC", "DueDate", "Name", "Notes", "RecurringTransactionId", "TransactionClearedUTC", "TransactionPendingUTC", "TransactionType" },
                values: new object[,]
                {
                    { new Guid("701fbe32-2d08-45a2-92f7-4922879154f2"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), -83.36m, 2028.48m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "Personal Loan", "", new Guid("99357fe4-d5ca-49a8-a554-5152e1fe3d8c"), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("a9c29086-aaad-44f5-a671-f8a32bb0895a"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), -472.12m, 383.57m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "Health Insurance", "", new Guid("68dd3256-8d7b-458e-be17-ffc052273299"), new DateTime(2023, 11, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("ab9b793f-f71e-47fb-bbb7-7615d65c7a61"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), -150.00m, 855.69m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "WF: Windows", "", new Guid("ebcbc1c2-994d-4461-8f93-c2f0da45c871"), new DateTime(2023, 11, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("d61aa8db-e71f-4d0c-b516-14e5ec699b32"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), -104.00m, 1924.48m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "Verizon", "", new Guid("d8245289-7405-4cc0-8e42-2fe4d5114d3b"), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" },
                    { new Guid("dd46c58d-f01b-42e4-98a2-97e53adb6c6b"), new Guid("1e39c60a-db25-4035-ba58-b292a4d6215a"), -80.72m, 1005.69m, "00000000-0000-0000-0000-000000000000", new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, null, "AT&T", "", new Guid("f0016241-6925-4b44-8f39-eb0c6f0c841a"), new DateTime(2023, 11, 26, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 11, 24, 0, 0, 0, 0, DateTimeKind.Unspecified), "Debit" }
                });

            migrationBuilder.InsertData(
                table: "Link_Categories_Transactions",
                columns: new[] { "CategoryId", "TransactionId" },
                values: new object[,]
                {
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("701fbe32-2d08-45a2-92f7-4922879154f2") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("a9c29086-aaad-44f5-a671-f8a32bb0895a") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("ab9b793f-f71e-47fb-bbb7-7615d65c7a61") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("d61aa8db-e71f-4d0c-b516-14e5ec699b32") },
                    { new Guid("0928f11d-219b-4cfc-9130-b363e6eedf1d"), new Guid("dd46c58d-f01b-42e4-98a2-97e53adb6c6b") }
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
                name: "IX_Link_Categories_Transactions_TransactionId",
                table: "Link_Categories_Transactions",
                column: "TransactionId");

            migrationBuilder.CreateIndex(
                name: "IX_Link_Category_RecurringTransactions_RecurringTransactionId",
                table: "Link_Category_RecurringTransactions",
                column: "RecurringTransactionId");

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
                name: "TransactionGroups");

            migrationBuilder.DropTable(
                name: "AspNetUsers");
        }
    }
}
