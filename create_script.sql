USE [master]
GO
/****** Object:  Database [solturadb]    Script Date: 12/4/2025 16:36:44 ******/
CREATE DATABASE [solturadb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'solturadb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\solturadb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'solturadb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\solturadb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [solturadb] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [solturadb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [solturadb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [solturadb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [solturadb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [solturadb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [solturadb] SET ARITHABORT OFF 
GO
ALTER DATABASE [solturadb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [solturadb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [solturadb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [solturadb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [solturadb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [solturadb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [solturadb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [solturadb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [solturadb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [solturadb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [solturadb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [solturadb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [solturadb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [solturadb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [solturadb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [solturadb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [solturadb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [solturadb] SET RECOVERY FULL 
GO
ALTER DATABASE [solturadb] SET  MULTI_USER 
GO
ALTER DATABASE [solturadb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [solturadb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [solturadb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [solturadb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [solturadb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [solturadb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'solturadb', N'ON'
GO
ALTER DATABASE [solturadb] SET QUERY_STORE = ON
GO
ALTER DATABASE [solturadb] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [solturadb]
GO
/****** Object:  Schema [paymentdb]    Script Date: 12/4/2025 16:36:44 ******/
CREATE SCHEMA [paymentdb]
GO
/****** Object:  UserDefinedFunction [paymentdb].[enum2str$soltura_schedules$endtype]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [paymentdb].[enum2str$soltura_schedules$endtype] 
( 
   @setval tinyint
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 1 THEN 'Date'
            WHEN 2 THEN 'Event'
            ELSE ''
         END
   END
GO
/****** Object:  UserDefinedFunction [paymentdb].[enum2str$soltura_schedules$recurrencytype]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [paymentdb].[enum2str$soltura_schedules$recurrencytype] 
( 
   @setval tinyint
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 1 THEN 'Daily'
            WHEN 2 THEN 'Weekly'
            WHEN 3 THEN 'Monthly'
            WHEN 4 THEN 'Annually'
            ELSE ''
         END
   END
GO
/****** Object:  UserDefinedFunction [paymentdb].[norm_enum$soltura_schedules$endtype]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [paymentdb].[norm_enum$soltura_schedules$endtype] 
( 
   @setval nvarchar(max)
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN paymentdb.enum2str$soltura_schedules$endtype(paymentdb.str2enum$soltura_schedules$endtype(@setval))
   END
GO
/****** Object:  UserDefinedFunction [paymentdb].[norm_enum$soltura_schedules$recurrencytype]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [paymentdb].[norm_enum$soltura_schedules$recurrencytype] 
( 
   @setval nvarchar(max)
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN paymentdb.enum2str$soltura_schedules$recurrencytype(paymentdb.str2enum$soltura_schedules$recurrencytype(@setval))
   END
GO
/****** Object:  UserDefinedFunction [paymentdb].[str2enum$soltura_schedules$endtype]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [paymentdb].[str2enum$soltura_schedules$endtype] 
( 
   @setval nvarchar(max)
)
RETURNS tinyint
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 'Date' THEN 1
            WHEN 'Event' THEN 2
            ELSE 0
         END
   END
GO
/****** Object:  UserDefinedFunction [paymentdb].[str2enum$soltura_schedules$recurrencytype]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [paymentdb].[str2enum$soltura_schedules$recurrencytype] 
( 
   @setval nvarchar(max)
)
RETURNS tinyint
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 'Daily' THEN 1
            WHEN 'Weekly' THEN 2
            WHEN 'Monthly' THEN 3
            WHEN 'Annually' THEN 4
            ELSE 0
         END
   END
GO
/****** Object:  Table [paymentdb].[soltura_addresses]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_addresses](
	[addressid] [int] IDENTITY(1,1) NOT NULL,
	[line1] [nvarchar](200) NULL,
	[line2] [nvarchar](200) NULL,
	[zipcode] [nvarchar](9) NOT NULL,
	[cityid] [int] NOT NULL,
	[geoposition] [geometry] NOT NULL,
 CONSTRAINT [PK_soltura_addresses_addressid] PRIMARY KEY CLUSTERED 
(
	[addressid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_associatedCompanies]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_associatedCompanies](
	[associatedCompaniesid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](20) NOT NULL,
	[benefitid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_associatedCompanies_associatedCompaniesid] PRIMARY KEY CLUSTERED 
(
	[associatedCompaniesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_authplatforms]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_authplatforms](
	[authplatformid] [smallint] NOT NULL,
	[name] [nvarchar](20) NOT NULL,
	[secretkey] [varbinary](128) NOT NULL,
	[key] [varbinary](128) NOT NULL,
	[iconurl] [nvarchar](200) NULL,
 CONSTRAINT [PK_soltura_authplatforms_authplatformid] PRIMARY KEY CLUSTERED 
(
	[authplatformid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_authsession]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_authsession](
	[authsessionid] [int] IDENTITY(1,1) NOT NULL,
	[sessionid] [varbinary](16) NOT NULL,
	[externaluser] [varbinary](16) NOT NULL,
	[token] [varbinary](128) NOT NULL,
	[refreshtoken] [datetime2](0) NOT NULL,
	[userid] [int] NOT NULL,
	[authplatformid] [smallint] NOT NULL,
 CONSTRAINT [PK_soltura_authsession_authsessionid] PRIMARY KEY CLUSTERED 
(
	[authsessionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_availablemethods]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_availablemethods](
	[availablemethodid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[token] [varbinary](128) NOT NULL,
	[exptokendate] [datetime2](0) NOT NULL,
	[maskaccount] [nvarchar](20) NOT NULL,
	[userid] [int] NOT NULL,
	[methodid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_availablemethods_availablemethodid] PRIMARY KEY CLUSTERED 
(
	[availablemethodid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_balances]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_balances](
	[balanceid] [bigint] IDENTITY(1,1) NOT NULL,
	[balance] [real] NOT NULL,
	[lastbalance] [real] NOT NULL,
	[lastupdate] [datetime2](0) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[freezeamount] [real] NOT NULL,
	[userid] [int] NOT NULL,
	[fundid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_balances_balanceid] PRIMARY KEY CLUSTERED 
(
	[balanceid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_benefits]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_benefits](
	[benefitsid] [int] IDENTITY(1,1) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[description] [nvarchar](60) NOT NULL,
	[availableuntil] [datetime2](0) NOT NULL,
	[subscriptionid] [int] NOT NULL,
	[planpersonid] [int] NOT NULL,
	[categorybenefitsid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_benefits_benefitsid] PRIMARY KEY CLUSTERED 
(
	[benefitsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_benefitsquantity]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_benefitsquantity](
	[benefittypesid] [int] IDENTITY(1,1) NOT NULL,
	[amount] [real] NOT NULL,
	[featureunit] [nvarchar](20) NOT NULL,
	[benefitid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_benefitsquantity_benefittypesid] PRIMARY KEY CLUSTERED 
(
	[benefittypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_categorybenefits]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_categorybenefits](
	[categorybenefitsid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_soltura_categorybenefits_categorybenefitsid] PRIMARY KEY CLUSTERED 
(
	[categorybenefitsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_cities]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_cities](
	[cityid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](60) NOT NULL,
	[stateid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_cities_cityid] PRIMARY KEY CLUSTERED 
(
	[cityid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_companiesContactinfo]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_companiesContactinfo](
	[companiesContactinfoid] [int] IDENTITY(1,1) NOT NULL,
	[value] [nvarchar](100) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[lastupdate] [datetime2](0) NOT NULL,
	[companyinfotypeId] [int] NOT NULL,
	[associatedCompaniesid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_companiesContactinfo_companiesContactinfoid] PRIMARY KEY CLUSTERED 
(
	[companiesContactinfoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_companyinfotypes]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_companyinfotypes](
	[companyinfotypeId] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_soltura_companyinfotypes_companyinfotypeId] PRIMARY KEY CLUSTERED 
(
	[companyinfotypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_contractDetails]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_contractDetails](
	[contractDetailid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[description] [nvarchar](100) NOT NULL,
	[value] [nvarchar](45) NOT NULL,
	[contractid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_contractDetails_contractDetailid] PRIMARY KEY CLUSTERED 
(
	[contractDetailid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_contracts]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_contracts](
	[contractid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[minimumaccounts] [int] NOT NULL,
	[date] [datetime2](0) NOT NULL,
	[expirationdate] [datetime2](0) NOT NULL,
	[solturaporcentage] [real] NOT NULL,
	[companyporcentage] [real] NOT NULL,
	[price] [real] NOT NULL,
	[associatedCompaniesid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_contracts_contractid] PRIMARY KEY CLUSTERED 
(
	[contractid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_countries]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_countries](
	[countryid] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](60) NOT NULL,
	[language] [nvarchar](7) NULL,
	[currencyid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_countries_countryid] PRIMARY KEY CLUSTERED 
(
	[countryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_currency]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_currency](
	[currencyid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](25) NOT NULL,
	[acronym] [nvarchar](5) NOT NULL,
	[symbol] [nvarchar](1) NOT NULL,
 CONSTRAINT [PK_soltura_currency_currencyid] PRIMARY KEY CLUSTERED 
(
	[currencyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_exchangerate]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_exchangerate](
	[exchangerateid] [int] IDENTITY(1,1) NOT NULL,
	[startdate] [datetime2](0) NOT NULL,
	[enddate] [datetime2](0) NOT NULL,
	[exchangerate] [decimal](15, 8) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[currentexchangerate] [binary](1) NOT NULL,
	[sourcecurrencyid] [int] NOT NULL,
	[destinycurrencyid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_exchangerate_exchangerateid] PRIMARY KEY CLUSTERED 
(
	[exchangerateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_funds]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_funds](
	[fundid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NULL,
 CONSTRAINT [PK_soltura_funds_fundid] PRIMARY KEY CLUSTERED 
(
	[fundid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_languages]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_languages](
	[languagesid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[culture] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_soltura_languages_languagesid] PRIMARY KEY CLUSTERED 
(
	[languagesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_logs]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_logs](
	[logsid] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](120) NOT NULL,
	[posttime] [datetime2](0) NOT NULL,
	[computer] [nvarchar](45) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[trace] [nvarchar](100) NOT NULL,
	[referenceid1] [bigint] NULL,
	[referenceid2] [bigint] NULL,
	[value1] [int] NULL,
	[value2] [int] NULL,
	[checksum] [varbinary](250) NOT NULL,
	[logtypesid] [int] NOT NULL,
	[logsourcesid] [int] NOT NULL,
	[logseverityid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_logs_logsid] PRIMARY KEY CLUSTERED 
(
	[logsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_logseverity]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_logseverity](
	[logseverityid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_soltura_logseverity_logseverityid] PRIMARY KEY CLUSTERED 
(
	[logseverityid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_logsources]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_logsources](
	[logsourcesid] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_soltura_logsources_logsourcesid] PRIMARY KEY CLUSTERED 
(
	[logsourcesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_logtypes]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_logtypes](
	[logtypesid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[ref1description] [nvarchar](120) NOT NULL,
	[ref2description] [nvarchar](120) NOT NULL,
	[val1description] [nvarchar](120) NOT NULL,
	[val2description] [nvarchar](120) NOT NULL,
	[payment_logtypescol] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_soltura_logtypes_logtypesid] PRIMARY KEY CLUSTERED 
(
	[logtypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_mediafiles]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_mediafiles](
	[mediafileid] [int] IDENTITY(1,1) NOT NULL,
	[mediapath] [nvarchar](300) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastupdate] [datetime2](0) NOT NULL,
	[userid] [int] NOT NULL,
	[mediatypeid] [smallint] NOT NULL,
	[sizeMB] [int] NOT NULL,
	[encoding] [nvarchar](20) NOT NULL,
	[samplerate] [int] NOT NULL,
	[languagecode] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_soltura_mediafiles_mediafileid] PRIMARY KEY CLUSTERED 
(
	[mediafileid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_mediatypes]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_mediatypes](
	[mediatypeid] [smallint] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[playerimpl] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_soltura_mediatypes_mediatypeid] PRIMARY KEY CLUSTERED 
(
	[mediatypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_modules]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_modules](
	[moduleid] [smallint] NOT NULL,
	[name] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_soltura_modules_moduleid] PRIMARY KEY CLUSTERED 
(
	[moduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_payment]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_payment](
	[paymentid] [bigint] IDENTITY(1,1) NOT NULL,
	[amount] [bigint] NOT NULL,
	[actualamount] [bigint] NOT NULL,
	[result] [smallint] NOT NULL,
	[reference] [nvarchar](100) NOT NULL,
	[auth] [nvarchar](60) NOT NULL,
	[chargetoken] [varbinary](128) NOT NULL,
	[description] [nvarchar](120) NULL,
	[error] [nvarchar](120) NULL,
	[date] [datetime2](0) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[moduleid] [smallint] NOT NULL,
	[methodid] [int] NOT NULL,
	[availablemethodid] [int] NOT NULL,
	[userid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_payment_paymentid] PRIMARY KEY CLUSTERED 
(
	[paymentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_paymentmethods]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_paymentmethods](
	[methodid] [int] NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[APIURL] [nvarchar](225) NOT NULL,
	[secretkey] [varbinary](128) NOT NULL,
	[key] [varbinary](128) NOT NULL,
	[logoiconurl] [nvarchar](225) NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_soltura_paymentmethods_methodid] PRIMARY KEY CLUSTERED 
(
	[methodid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_permissions]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_permissions](
	[permissionid] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](100) NOT NULL,
	[code] [nvarchar](10) NOT NULL,
	[moduleid] [smallint] NOT NULL,
 CONSTRAINT [PK_soltura_permissions_permissionid] PRIMARY KEY CLUSTERED 
(
	[permissionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_planperson]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_planperson](
	[planpersonid] [int] IDENTITY(1,1) NOT NULL,
	[acquisition] [datetime2](0) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[scheduleid] [int] NOT NULL,
	[planpricesid] [int] NOT NULL,
	[expirationdate] [date] NOT NULL,
	[maxaccounts] [int] NOT NULL,
 CONSTRAINT [PK_soltura_planperson_planpersonid] PRIMARY KEY CLUSTERED 
(
	[planpersonid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_planperson_users]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_planperson_users](
	[planpersonid] [int] NOT NULL,
	[userid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_planperson_users_planpersonid] PRIMARY KEY CLUSTERED 
(
	[planpersonid] ASC,
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_planprices]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_planprices](
	[planpricesid] [int] IDENTITY(1,1) NOT NULL,
	[amount] [bigint] NOT NULL,
	[recurrencytype] [smallint] NOT NULL,
	[posttime] [datetime2](0) NOT NULL,
	[endate] [datetime2](0) NOT NULL,
	[current] [binary](1) NOT NULL,
	[currencyid] [int] NOT NULL,
	[subscriptionid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_planprices_planpricesid] PRIMARY KEY CLUSTERED 
(
	[planpricesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_redemptionMethods]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_redemptionMethods](
	[redemptionMethodsid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](20) NOT NULL,
	[value] [nvarchar](300) NOT NULL,
 CONSTRAINT [PK_soltura_redemptionMethods_redemptionMethodsid] PRIMARY KEY CLUSTERED 
(
	[redemptionMethodsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_redemptions]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_redemptions](
	[redemptionid] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime2](0) NOT NULL,
	[redemptionMethodsid] [int] NOT NULL,
	[userid] [int] NOT NULL,
	[benefitsid] [int] NOT NULL,
	[reference1] [bigint] NOT NULL,
	[reference2] [bigint] NOT NULL,
	[value1] [nvarchar](100) NOT NULL,
	[value2] [nvarchar](100) NOT NULL,
	[checksum] [varbinary](255) NOT NULL,
	[scheduleid] [int],
 CONSTRAINT [PK_soltura_redemptions_redemptionid] PRIMARY KEY CLUSTERED 
(
	[redemptionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_roles]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_roles](
	[roleid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_soltura_roles_roleid] PRIMARY KEY CLUSTERED 
(
	[roleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_rolespermission]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_rolespermission](
	[rolepermissionid] [int] IDENTITY(1,1) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastupdate] [datetime2](0) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[roleid] [int] NOT NULL,
	[permissionid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_rolespermission_rolepermissionid] PRIMARY KEY CLUSTERED 
(
	[rolepermissionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_scheduledetails]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_scheduledetails](
	[scheduledetailsid] [int] IDENTITY(1,1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[basedate] [datetime2](0) NOT NULL,
	[datepart] [nvarchar](20) NOT NULL,
	[lastexcecution] [datetime2](0) NOT NULL,
	[nextexcecution] [datetime2](0) NOT NULL,
	[scheduleid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_scheduledetails_scheduledetailsid] PRIMARY KEY CLUSTERED 
(
	[scheduledetailsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_schedules]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_schedules](
	[scheduleid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[recurrencytype] [nvarchar](8) NOT NULL,
	[endtype] [nvarchar](5) NOT NULL,
	[repetitions] [int] NULL,
	[enddate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_soltura_schedules_scheduleid] PRIMARY KEY CLUSTERED 
(
	[scheduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_states]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_states](
	[stateid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[countryid] [smallint] NOT NULL,
 CONSTRAINT [PK_soltura_states_stateid] PRIMARY KEY CLUSTERED 
(
	[stateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_subscriptions]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_subscriptions](
	[subscriptionid] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](120) NOT NULL,
	[logourl] [nvarchar](225) NOT NULL,
	[startdate] [datetime2](0) NOT NULL,
	[endate] [datetime2](0) NULL,
	[autorenew] [binary](1) NOT NULL,
 CONSTRAINT [PK_soltura_subscriptions_subscriptionid] PRIMARY KEY CLUSTERED 
(
	[subscriptionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_transactions]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_transactions](
	[transactionid] [int] IDENTITY(1,1) NOT NULL,
	[amount] [bigint] NOT NULL,
	[description] [nvarchar](120) NULL,
	[date] [datetime2](0) NOT NULL,
	[posttime] [datetime2](0) NOT NULL,
	[reference1] [bigint] NOT NULL,
	[reference2] [bigint] NOT NULL,
	[value1] [nvarchar](100) NOT NULL,
	[value2] [nvarchar](100) NOT NULL,
	[processmanagerid] [int] NOT NULL,
	[convertedamount] [bigint] NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[transtypeid] [int] NOT NULL,
	[transsubtypesid] [int] NOT NULL,
	[paymentid] [bigint] NULL,
	[currencyid] [int] NOT NULL,
	[exchangerateid] [int] NOT NULL,
	[scheduleid] [int] NULL,
	[balanceid] [bigint] NOT NULL,
	[fundid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_transactions_transactionid] PRIMARY KEY CLUSTERED 
(
	[transactionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_translation]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_translation](
	[translationid] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](20) NOT NULL,
	[caption] [nvarchar](max) NOT NULL,
	[enabled] [binary](1) NULL,
	[languagesid] [int] NOT NULL,
	[moduleid] [smallint] NOT NULL,
 CONSTRAINT [PK_soltura_translation_translationid] PRIMARY KEY CLUSTERED 
(
	[translationid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_transsubtypes]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_transsubtypes](
	[transsubtypesid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_soltura_transsubtypes_transsubtypesid] PRIMARY KEY CLUSTERED 
(
	[transsubtypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_transtypes]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_transtypes](
	[transtypeid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_soltura_transtypes_transtypeid] PRIMARY KEY CLUSTERED 
(
	[transtypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_useraddress]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_useraddress](
	[userid] [int] NOT NULL,
	[addressid] [int] NOT NULL,
	[useraddressid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_useraddress_userid] PRIMARY KEY CLUSTERED 
(
	[userid] ASC,
	[addressid] ASC,
	[useraddressid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_userinfo]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_userinfo](
	[userinfoid] [int] IDENTITY(1,1) NOT NULL,
	[value] [nvarchar](100) NULL,
	[enabled] [binary](1) NOT NULL,
	[lastupdate] [datetime2](0) NULL,
	[userid] [int] NOT NULL,
	[userinfotypesid] [int] NOT NULL,
	[methodid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_userinfo_userinfoid] PRIMARY KEY CLUSTERED 
(
	[userinfoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_userinfotypes]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_userinfotypes](
	[userinfotypesid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_soltura_userinfotypes_userinfotypesid] PRIMARY KEY CLUSTERED 
(
	[userinfotypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_userpermissions]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_userpermissions](
	[rolepermissionid] [int] IDENTITY(1,1) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastupdate] [datetime2](0) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[userid] [int] NOT NULL,
	[permissionid] [int] NOT NULL,
 CONSTRAINT [PK_soltura_userpermissions_rolepermissionid] PRIMARY KEY CLUSTERED 
(
	[rolepermissionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_users]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_users](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](80) NOT NULL,
	[firstname] [nvarchar](50) NOT NULL,
	[lastname] [nvarchar](50) NOT NULL,
	[birthday] [date] NOT NULL,
	[password] [varbinary](250) NULL,
	[companyid] [int] NULL,
 CONSTRAINT [PK_soltura_users_userid] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [soltura_users$email_UNIQUE] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [paymentdb].[soltura_usersroles]    Script Date: 12/4/2025 16:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [paymentdb].[soltura_usersroles](
	[roleid] [int] NOT NULL,
	[userid] [int] NOT NULL,
	[lastupdate] [datetime2](0) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
 CONSTRAINT [PK_soltura_usersroles_roleid] PRIMARY KEY CLUSTERED 
(
	[roleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_addresses_payment_cities1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_addresses_payment_cities1_idx] ON [paymentdb].[soltura_addresses]
(
	[cityid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_services_payment_featuresperplan1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_services_payment_featuresperplan1_idx] ON [paymentdb].[soltura_associatedCompanies]
(
	[benefitid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_authsession_payment_authplatforms1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_authsession_payment_authplatforms1_idx] ON [paymentdb].[soltura_authsession]
(
	[authplatformid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_authsession_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_authsession_payment_users1_idx] ON [paymentdb].[soltura_authsession]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_availablemethods_payment_paymentmethods1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_availablemethods_payment_paymentmethods1_idx] ON [paymentdb].[soltura_availablemethods]
(
	[methodid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_availablemethods_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_availablemethods_payment_users1_idx] ON [paymentdb].[soltura_availablemethods]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_balances_soltura_funds1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_balances_soltura_funds1_idx] ON [paymentdb].[soltura_balances]
(
	[fundid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_balances_soltura_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_balances_soltura_users1_idx] ON [paymentdb].[soltura_balances]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_featuresperplan_payment_subscriptions1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_featuresperplan_payment_subscriptions1_idx] ON [paymentdb].[soltura_benefits]
(
	[subscriptionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_benefits_soltura_categorybenefits1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_benefits_soltura_categorybenefits1_idx] ON [paymentdb].[soltura_benefits]
(
	[categorybenefitsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_benefits_soltura_planperson1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_benefits_soltura_planperson1_idx] ON [paymentdb].[soltura_benefits]
(
	[planpersonid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_featurestypes_payment_featuresperplan1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_featurestypes_payment_featuresperplan1_idx] ON [paymentdb].[soltura_benefitsquantity]
(
	[benefitid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_cities_payment_states1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_cities_payment_states1_idx] ON [paymentdb].[soltura_cities]
(
	[stateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_companiesContactinfo_soltura_associatedCompanies_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_companiesContactinfo_soltura_associatedCompanies_idx] ON [paymentdb].[soltura_companiesContactinfo]
(
	[associatedCompaniesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_companiesContactinfo_soltura_companyinfotypes1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_companiesContactinfo_soltura_companyinfotypes1_idx] ON [paymentdb].[soltura_companiesContactinfo]
(
	[companyinfotypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_contractDetails_soltura_contracts1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_contractDetails_soltura_contracts1_idx] ON [paymentdb].[soltura_contractDetails]
(
	[contractid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_contracts_soltura_associatedCompanies1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_contracts_soltura_associatedCompanies1_idx] ON [paymentdb].[soltura_contracts]
(
	[associatedCompaniesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_countries_payment_currency1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_countries_payment_currency1_idx] ON [paymentdb].[soltura_countries]
(
	[currencyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_exchangerate_payment_currency1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_exchangerate_payment_currency1_idx] ON [paymentdb].[soltura_exchangerate]
(
	[sourcecurrencyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_exchangerate_payment_currency2_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_exchangerate_payment_currency2_idx] ON [paymentdb].[soltura_exchangerate]
(
	[destinycurrencyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_logs_payment_logseverity1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_logs_payment_logseverity1_idx] ON [paymentdb].[soltura_logs]
(
	[logseverityid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_logs_payment_logsources1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_logs_payment_logsources1_idx] ON [paymentdb].[soltura_logs]
(
	[logsourcesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_logs_payment_logtypes1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_logs_payment_logtypes1_idx] ON [paymentdb].[soltura_logs]
(
	[logtypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_mediafiles_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_mediafiles_payment_users1_idx] ON [paymentdb].[soltura_mediafiles]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_mediafiles_pets_mediatypes1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_mediafiles_pets_mediatypes1_idx] ON [paymentdb].[soltura_mediafiles]
(
	[mediatypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_payment_payment_availablemethods1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_payment_payment_availablemethods1_idx] ON [paymentdb].[soltura_payment]
(
	[availablemethodid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_payment_payment_modules1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_payment_payment_modules1_idx] ON [paymentdb].[soltura_payment]
(
	[moduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_payment_payment_paymentmethods1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_payment_payment_paymentmethods1_idx] ON [paymentdb].[soltura_payment]
(
	[methodid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_payment_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_payment_payment_users1_idx] ON [paymentdb].[soltura_payment]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_permissions_payment_modules1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_permissions_payment_modules1_idx] ON [paymentdb].[soltura_permissions]
(
	[moduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_planperson_payment_planprices1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_planperson_payment_planprices1_idx] ON [paymentdb].[soltura_planperson]
(
	[planpricesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_planperson_payment_schedules1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_planperson_payment_schedules1_idx] ON [paymentdb].[soltura_planperson]
(
	[scheduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_planperson_has_payment_users_payment_planperson1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_planperson_has_payment_users_payment_planperson1_idx] ON [paymentdb].[soltura_planperson_users]
(
	[planpersonid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_planperson_has_payment_users_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_planperson_has_payment_users_payment_users1_idx] ON [paymentdb].[soltura_planperson_users]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_planprices_payment_currency1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_planprices_payment_currency1_idx] ON [paymentdb].[soltura_planprices]
(
	[currencyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_planprices_payment_subscriptions1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_planprices_payment_subscriptions1_idx] ON [paymentdb].[soltura_planprices]
(
	[subscriptionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_redemptions_soltura_benefits1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_redemptions_soltura_benefits1_idx] ON [paymentdb].[soltura_redemptions]
(
	[benefitsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_redemptions_soltura_redemptionMethods1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_redemptions_soltura_redemptionMethods1_idx] ON [paymentdb].[soltura_redemptions]
(
	[redemptionMethodsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_redemptions_soltura_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_redemptions_soltura_users1_idx] ON [paymentdb].[soltura_redemptions]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_rolespermission_payment_permissions1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_rolespermission_payment_permissions1_idx] ON [paymentdb].[soltura_rolespermission]
(
	[permissionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_rolespermission_payment_roles1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_rolespermission_payment_roles1_idx] ON [paymentdb].[soltura_rolespermission]
(
	[roleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_scheduledetails_payment_schedules1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_scheduledetails_payment_schedules1_idx] ON [paymentdb].[soltura_scheduledetails]
(
	[scheduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_states_payment_countries1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_states_payment_countries1_idx] ON [paymentdb].[soltura_states]
(
	[countryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_transactions_payment_currency1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_transactions_payment_currency1_idx] ON [paymentdb].[soltura_transactions]
(
	[currencyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_transactions_payment_exchangerate1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_transactions_payment_exchangerate1_idx] ON [paymentdb].[soltura_transactions]
(
	[exchangerateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_transactions_payment_payment1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_transactions_payment_payment1_idx] ON [paymentdb].[soltura_transactions]
(
	[paymentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_transactions_payment_schedules1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_transactions_payment_schedules1_idx] ON [paymentdb].[soltura_transactions]
(
	[scheduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_transactions_payment_transsubtypes1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_transactions_payment_transsubtypes1_idx] ON [paymentdb].[soltura_transactions]
(
	[transsubtypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_transactions_payment_transtypes1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_transactions_payment_transtypes1_idx] ON [paymentdb].[soltura_transactions]
(
	[transtypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_transactions_soltura_balances1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_transactions_soltura_balances1_idx] ON [paymentdb].[soltura_transactions]
(
	[balanceid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_soltura_transactions_soltura_funds1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_soltura_transactions_soltura_funds1_idx] ON [paymentdb].[soltura_transactions]
(
	[fundid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_translation_payment_languages1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_translation_payment_languages1_idx] ON [paymentdb].[soltura_translation]
(
	[languagesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_translation_payment_modules1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_translation_payment_modules1_idx] ON [paymentdb].[soltura_translation]
(
	[moduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_users_has_payment_addresses_payment_addresses1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_users_has_payment_addresses_payment_addresses1_idx] ON [paymentdb].[soltura_useraddress]
(
	[addressid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_users_has_payment_addresses_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_users_has_payment_addresses_payment_users1_idx] ON [paymentdb].[soltura_useraddress]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_userinfo_payment_paymentmethods1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_userinfo_payment_paymentmethods1_idx] ON [paymentdb].[soltura_userinfo]
(
	[methodid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_userinfo_payment_userinfotypes1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_userinfo_payment_userinfotypes1_idx] ON [paymentdb].[soltura_userinfo]
(
	[userinfotypesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_userinfo_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_userinfo_payment_users1_idx] ON [paymentdb].[soltura_userinfo]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_userpermissions_payment_permissions1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_userpermissions_payment_permissions1_idx] ON [paymentdb].[soltura_userpermissions]
(
	[permissionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_userpermissions_payment_users_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_userpermissions_payment_users_idx] ON [paymentdb].[soltura_userpermissions]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_roles_has_payment_users_payment_roles1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_roles_has_payment_users_payment_roles1_idx] ON [paymentdb].[soltura_usersroles]
(
	[roleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [fk_payment_roles_has_payment_users_payment_users1_idx]    Script Date: 12/4/2025 16:36:44 ******/
CREATE NONCLUSTERED INDEX [fk_payment_roles_has_payment_users_payment_users1_idx] ON [paymentdb].[soltura_usersroles]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [paymentdb].[soltura_addresses] ADD  DEFAULT (NULL) FOR [line1]
GO
ALTER TABLE [paymentdb].[soltura_addresses] ADD  DEFAULT (NULL) FOR [line2]
GO
ALTER TABLE [paymentdb].[soltura_authplatforms] ADD  DEFAULT (NULL) FOR [iconurl]
GO
ALTER TABLE [paymentdb].[soltura_authsession] ADD  DEFAULT (getdate()) FOR [refreshtoken]
GO
ALTER TABLE [paymentdb].[soltura_availablemethods] ADD  DEFAULT (getdate()) FOR [exptokendate]
GO
ALTER TABLE [paymentdb].[soltura_balances] ADD  DEFAULT (getdate()) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_benefits] ADD  DEFAULT (0x00) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_categorybenefits] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_companiesContactinfo] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_companiesContactinfo] ADD  DEFAULT (getdate()) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_countries] ADD  DEFAULT (NULL) FOR [language]
GO
ALTER TABLE [paymentdb].[soltura_exchangerate] ADD  DEFAULT (getdate()) FOR [startdate]
GO
ALTER TABLE [paymentdb].[soltura_exchangerate] ADD  DEFAULT (getdate()) FOR [enddate]
GO
ALTER TABLE [paymentdb].[soltura_exchangerate] ADD  DEFAULT (0x00) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_exchangerate] ADD  DEFAULT (0x00) FOR [currentexchangerate]
GO
ALTER TABLE [paymentdb].[soltura_funds] ADD  DEFAULT (NULL) FOR [name]
GO
ALTER TABLE [paymentdb].[soltura_logs] ADD  DEFAULT (getdate()) FOR [posttime]
GO
ALTER TABLE [paymentdb].[soltura_logs] ADD  DEFAULT (NULL) FOR [referenceid1]
GO
ALTER TABLE [paymentdb].[soltura_logs] ADD  DEFAULT (NULL) FOR [referenceid2]
GO
ALTER TABLE [paymentdb].[soltura_logs] ADD  DEFAULT (NULL) FOR [value1]
GO
ALTER TABLE [paymentdb].[soltura_logs] ADD  DEFAULT (NULL) FOR [value2]
GO
ALTER TABLE [paymentdb].[soltura_mediafiles] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [paymentdb].[soltura_mediafiles] ADD  DEFAULT (getdate()) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_payment] ADD  DEFAULT (NULL) FOR [description]
GO
ALTER TABLE [paymentdb].[soltura_payment] ADD  DEFAULT (NULL) FOR [error]
GO
ALTER TABLE [paymentdb].[soltura_paymentmethods] ADD  DEFAULT (NULL) FOR [logoiconurl]
GO
ALTER TABLE [paymentdb].[soltura_paymentmethods] ADD  DEFAULT (0x00) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_planperson] ADD  DEFAULT (getdate()) FOR [acquisition]
GO
ALTER TABLE [paymentdb].[soltura_planperson] ADD  DEFAULT (0x00) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_planprices] ADD  DEFAULT (getdate()) FOR [posttime]
GO
ALTER TABLE [paymentdb].[soltura_planprices] ADD  DEFAULT (getdate()) FOR [endate]
GO
ALTER TABLE [paymentdb].[soltura_planprices] ADD  DEFAULT (0x00) FOR [current]
GO
ALTER TABLE [paymentdb].[soltura_rolespermission] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_rolespermission] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [paymentdb].[soltura_rolespermission] ADD  DEFAULT (getdate()) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_scheduledetails] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [paymentdb].[soltura_scheduledetails] ADD  DEFAULT (getdate()) FOR [lastexcecution]
GO
ALTER TABLE [paymentdb].[soltura_scheduledetails] ADD  DEFAULT (getdate()) FOR [nextexcecution]
GO
ALTER TABLE [paymentdb].[soltura_schedules] ADD  DEFAULT (NULL) FOR [repetitions]
GO
ALTER TABLE [paymentdb].[soltura_subscriptions] ADD  DEFAULT (NULL) FOR [endate]
GO
ALTER TABLE [paymentdb].[soltura_transactions] ADD  DEFAULT (NULL) FOR [description]
GO
ALTER TABLE [paymentdb].[soltura_transactions] ADD  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [paymentdb].[soltura_transactions] ADD  DEFAULT (getdate()) FOR [posttime]
GO
ALTER TABLE [paymentdb].[soltura_transactions] ADD  DEFAULT (NULL) FOR [paymentid]
GO
ALTER TABLE [paymentdb].[soltura_transactions] ADD  DEFAULT (NULL) FOR [scheduleid]
GO
ALTER TABLE [paymentdb].[soltura_translation] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_userinfo] ADD  DEFAULT (NULL) FOR [value]
GO
ALTER TABLE [paymentdb].[soltura_userinfo] ADD  DEFAULT (0x00) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_userinfo] ADD  DEFAULT (NULL) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_userpermissions] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_userpermissions] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [paymentdb].[soltura_userpermissions] ADD  DEFAULT (getdate()) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_users] ADD  DEFAULT (NULL) FOR [password]
GO
ALTER TABLE [paymentdb].[soltura_users] ADD  DEFAULT (NULL) FOR [companyid]
GO
ALTER TABLE [paymentdb].[soltura_usersroles] ADD  DEFAULT (getdate()) FOR [lastupdate]
GO
ALTER TABLE [paymentdb].[soltura_usersroles] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [paymentdb].[soltura_usersroles] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [paymentdb].[soltura_addresses]  WITH CHECK ADD  CONSTRAINT [soltura_addresses$fk_payment_addresses_payment_cities1] FOREIGN KEY([cityid])
REFERENCES [paymentdb].[soltura_cities] ([cityid])
GO
ALTER TABLE [paymentdb].[soltura_addresses] CHECK CONSTRAINT [soltura_addresses$fk_payment_addresses_payment_cities1]
GO
ALTER TABLE [paymentdb].[soltura_associatedCompanies]  WITH CHECK ADD  CONSTRAINT [soltura_associatedCompanies$fk_payment_services_payment_featuresperplan1] FOREIGN KEY([benefitid])
REFERENCES [paymentdb].[soltura_benefits] ([benefitsid])
GO
ALTER TABLE [paymentdb].[soltura_associatedCompanies] CHECK CONSTRAINT [soltura_associatedCompanies$fk_payment_services_payment_featuresperplan1]
GO
ALTER TABLE [paymentdb].[soltura_authsession]  WITH CHECK ADD  CONSTRAINT [soltura_authsession$fk_payment_authsession_payment_authplatforms1] FOREIGN KEY([authplatformid])
REFERENCES [paymentdb].[soltura_authplatforms] ([authplatformid])
GO
ALTER TABLE [paymentdb].[soltura_authsession] CHECK CONSTRAINT [soltura_authsession$fk_payment_authsession_payment_authplatforms1]
GO
ALTER TABLE [paymentdb].[soltura_authsession]  WITH CHECK ADD  CONSTRAINT [soltura_authsession$fk_payment_authsession_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_authsession] CHECK CONSTRAINT [soltura_authsession$fk_payment_authsession_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_availablemethods]  WITH CHECK ADD  CONSTRAINT [soltura_availablemethods$fk_payment_availablemethods_payment_paymentmethods1] FOREIGN KEY([methodid])
REFERENCES [paymentdb].[soltura_paymentmethods] ([methodid])
GO
ALTER TABLE [paymentdb].[soltura_availablemethods] CHECK CONSTRAINT [soltura_availablemethods$fk_payment_availablemethods_payment_paymentmethods1]
GO
ALTER TABLE [paymentdb].[soltura_availablemethods]  WITH CHECK ADD  CONSTRAINT [soltura_availablemethods$fk_payment_availablemethods_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_availablemethods] CHECK CONSTRAINT [soltura_availablemethods$fk_payment_availablemethods_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_balances]  WITH CHECK ADD  CONSTRAINT [soltura_balances$fk_soltura_balances_soltura_funds1] FOREIGN KEY([fundid])
REFERENCES [paymentdb].[soltura_funds] ([fundid])
GO
ALTER TABLE [paymentdb].[soltura_balances] CHECK CONSTRAINT [soltura_balances$fk_soltura_balances_soltura_funds1]
GO
ALTER TABLE [paymentdb].[soltura_balances]  WITH CHECK ADD  CONSTRAINT [soltura_balances$fk_soltura_balances_soltura_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_balances] CHECK CONSTRAINT [soltura_balances$fk_soltura_balances_soltura_users1]
GO
ALTER TABLE [paymentdb].[soltura_benefits]  WITH CHECK ADD  CONSTRAINT [soltura_benefits$fk_payment_featuresperplan_payment_subscriptions1] FOREIGN KEY([subscriptionid])
REFERENCES [paymentdb].[soltura_subscriptions] ([subscriptionid])
GO
ALTER TABLE [paymentdb].[soltura_benefits] CHECK CONSTRAINT [soltura_benefits$fk_payment_featuresperplan_payment_subscriptions1]
GO
ALTER TABLE [paymentdb].[soltura_benefits]  WITH CHECK ADD  CONSTRAINT [soltura_benefits$fk_soltura_benefits_soltura_categorybenefits1] FOREIGN KEY([categorybenefitsid])
REFERENCES [paymentdb].[soltura_categorybenefits] ([categorybenefitsid])
GO
ALTER TABLE [paymentdb].[soltura_benefits] CHECK CONSTRAINT [soltura_benefits$fk_soltura_benefits_soltura_categorybenefits1]
GO
ALTER TABLE [paymentdb].[soltura_benefits]  WITH CHECK ADD  CONSTRAINT [soltura_benefits$fk_soltura_benefits_soltura_planperson1] FOREIGN KEY([planpersonid])
REFERENCES [paymentdb].[soltura_planperson] ([planpersonid])
GO
ALTER TABLE [paymentdb].[soltura_benefits] CHECK CONSTRAINT [soltura_benefits$fk_soltura_benefits_soltura_planperson1]
GO
ALTER TABLE [paymentdb].[soltura_benefitsquantity]  WITH CHECK ADD  CONSTRAINT [soltura_benefitsquantity$fk_payment_featurestypes_payment_featuresperplan1] FOREIGN KEY([benefitid])
REFERENCES [paymentdb].[soltura_benefits] ([benefitsid])
GO
ALTER TABLE [paymentdb].[soltura_benefitsquantity] CHECK CONSTRAINT [soltura_benefitsquantity$fk_payment_featurestypes_payment_featuresperplan1]
GO
ALTER TABLE [paymentdb].[soltura_cities]  WITH CHECK ADD  CONSTRAINT [soltura_cities$fk_payment_cities_payment_states1] FOREIGN KEY([stateid])
REFERENCES [paymentdb].[soltura_states] ([stateid])
GO
ALTER TABLE [paymentdb].[soltura_cities] CHECK CONSTRAINT [soltura_cities$fk_payment_cities_payment_states1]
GO
ALTER TABLE [paymentdb].[soltura_companiesContactinfo]  WITH CHECK ADD  CONSTRAINT [soltura_companiesContactinfo$fk_soltura_companiesContactinfo_soltura_associatedCompanies1] FOREIGN KEY([associatedCompaniesid])
REFERENCES [paymentdb].[soltura_associatedCompanies] ([associatedCompaniesid])
GO
ALTER TABLE [paymentdb].[soltura_companiesContactinfo] CHECK CONSTRAINT [soltura_companiesContactinfo$fk_soltura_companiesContactinfo_soltura_associatedCompanies1]
GO
ALTER TABLE [paymentdb].[soltura_companiesContactinfo]  WITH CHECK ADD  CONSTRAINT [soltura_companiesContactinfo$fk_soltura_companiesContactinfo_soltura_companyinfotypes1] FOREIGN KEY([companyinfotypeId])
REFERENCES [paymentdb].[soltura_companyinfotypes] ([companyinfotypeId])
GO
ALTER TABLE [paymentdb].[soltura_companiesContactinfo] CHECK CONSTRAINT [soltura_companiesContactinfo$fk_soltura_companiesContactinfo_soltura_companyinfotypes1]
GO
ALTER TABLE [paymentdb].[soltura_contractDetails]  WITH CHECK ADD  CONSTRAINT [soltura_contractDetails$fk_soltura_contractDetails_soltura_contracts1] FOREIGN KEY([contractid])
REFERENCES [paymentdb].[soltura_contracts] ([contractid])
GO
ALTER TABLE [paymentdb].[soltura_contractDetails] CHECK CONSTRAINT [soltura_contractDetails$fk_soltura_contractDetails_soltura_contracts1]
GO
ALTER TABLE [paymentdb].[soltura_contracts]  WITH CHECK ADD  CONSTRAINT [soltura_contracts$fk_soltura_contracts_soltura_associatedCompanies1] FOREIGN KEY([associatedCompaniesid])
REFERENCES [paymentdb].[soltura_associatedCompanies] ([associatedCompaniesid])
GO
ALTER TABLE [paymentdb].[soltura_contracts] CHECK CONSTRAINT [soltura_contracts$fk_soltura_contracts_soltura_associatedCompanies1]
GO
ALTER TABLE [paymentdb].[soltura_countries]  WITH CHECK ADD  CONSTRAINT [soltura_countries$fk_payment_countries_payment_currency1] FOREIGN KEY([currencyid])
REFERENCES [paymentdb].[soltura_currency] ([currencyid])
GO
ALTER TABLE [paymentdb].[soltura_countries] CHECK CONSTRAINT [soltura_countries$fk_payment_countries_payment_currency1]
GO
ALTER TABLE [paymentdb].[soltura_exchangerate]  WITH CHECK ADD  CONSTRAINT [soltura_exchangerate$fk_payment_exchangerate_payment_currency1] FOREIGN KEY([sourcecurrencyid])
REFERENCES [paymentdb].[soltura_currency] ([currencyid])
GO
ALTER TABLE [paymentdb].[soltura_exchangerate] CHECK CONSTRAINT [soltura_exchangerate$fk_payment_exchangerate_payment_currency1]
GO
ALTER TABLE [paymentdb].[soltura_exchangerate]  WITH CHECK ADD  CONSTRAINT [soltura_exchangerate$fk_payment_exchangerate_payment_currency2] FOREIGN KEY([destinycurrencyid])
REFERENCES [paymentdb].[soltura_currency] ([currencyid])
GO
ALTER TABLE [paymentdb].[soltura_exchangerate] CHECK CONSTRAINT [soltura_exchangerate$fk_payment_exchangerate_payment_currency2]
GO
ALTER TABLE [paymentdb].[soltura_logs]  WITH CHECK ADD  CONSTRAINT [soltura_logs$fk_payment_logs_payment_logseverity1] FOREIGN KEY([logseverityid])
REFERENCES [paymentdb].[soltura_logseverity] ([logseverityid])
GO
ALTER TABLE [paymentdb].[soltura_logs] CHECK CONSTRAINT [soltura_logs$fk_payment_logs_payment_logseverity1]
GO
ALTER TABLE [paymentdb].[soltura_logs]  WITH CHECK ADD  CONSTRAINT [soltura_logs$fk_payment_logs_payment_logsources1] FOREIGN KEY([logsourcesid])
REFERENCES [paymentdb].[soltura_logsources] ([logsourcesid])
GO
ALTER TABLE [paymentdb].[soltura_logs] CHECK CONSTRAINT [soltura_logs$fk_payment_logs_payment_logsources1]
GO
ALTER TABLE [paymentdb].[soltura_logs]  WITH CHECK ADD  CONSTRAINT [soltura_logs$fk_payment_logs_payment_logtypes1] FOREIGN KEY([logtypesid])
REFERENCES [paymentdb].[soltura_logtypes] ([logtypesid])
GO
ALTER TABLE [paymentdb].[soltura_logs] CHECK CONSTRAINT [soltura_logs$fk_payment_logs_payment_logtypes1]
GO
ALTER TABLE [paymentdb].[soltura_mediafiles]  WITH CHECK ADD  CONSTRAINT [soltura_mediafiles$fk_payment_mediafiles_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_mediafiles] CHECK CONSTRAINT [soltura_mediafiles$fk_payment_mediafiles_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_mediafiles]  WITH CHECK ADD  CONSTRAINT [soltura_mediafiles$fk_payment_mediafiles_pets_mediatypes1] FOREIGN KEY([mediatypeid])
REFERENCES [paymentdb].[soltura_mediatypes] ([mediatypeid])
GO
ALTER TABLE [paymentdb].[soltura_mediafiles] CHECK CONSTRAINT [soltura_mediafiles$fk_payment_mediafiles_pets_mediatypes1]
GO
ALTER TABLE [paymentdb].[soltura_payment]  WITH CHECK ADD  CONSTRAINT [soltura_payment$fk_payment_payment_payment_availablemethods1] FOREIGN KEY([availablemethodid])
REFERENCES [paymentdb].[soltura_availablemethods] ([availablemethodid])
GO
ALTER TABLE [paymentdb].[soltura_payment] CHECK CONSTRAINT [soltura_payment$fk_payment_payment_payment_availablemethods1]
GO
ALTER TABLE [paymentdb].[soltura_payment]  WITH CHECK ADD  CONSTRAINT [soltura_payment$fk_payment_payment_payment_modules1] FOREIGN KEY([moduleid])
REFERENCES [paymentdb].[soltura_modules] ([moduleid])
GO
ALTER TABLE [paymentdb].[soltura_payment] CHECK CONSTRAINT [soltura_payment$fk_payment_payment_payment_modules1]
GO
ALTER TABLE [paymentdb].[soltura_payment]  WITH CHECK ADD  CONSTRAINT [soltura_payment$fk_payment_payment_payment_paymentmethods1] FOREIGN KEY([methodid])
REFERENCES [paymentdb].[soltura_paymentmethods] ([methodid])
GO
ALTER TABLE [paymentdb].[soltura_payment] CHECK CONSTRAINT [soltura_payment$fk_payment_payment_payment_paymentmethods1]
GO
ALTER TABLE [paymentdb].[soltura_payment]  WITH CHECK ADD  CONSTRAINT [soltura_payment$fk_payment_payment_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_payment] CHECK CONSTRAINT [soltura_payment$fk_payment_payment_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_permissions]  WITH CHECK ADD  CONSTRAINT [soltura_permissions$fk_payment_permissions_payment_modules1] FOREIGN KEY([moduleid])
REFERENCES [paymentdb].[soltura_modules] ([moduleid])
GO
ALTER TABLE [paymentdb].[soltura_permissions] CHECK CONSTRAINT [soltura_permissions$fk_payment_permissions_payment_modules1]
GO
ALTER TABLE [paymentdb].[soltura_planperson]  WITH CHECK ADD  CONSTRAINT [soltura_planperson$fk_payment_planperson_payment_planprices1] FOREIGN KEY([planpricesid])
REFERENCES [paymentdb].[soltura_planprices] ([planpricesid])
GO
ALTER TABLE [paymentdb].[soltura_planperson] CHECK CONSTRAINT [soltura_planperson$fk_payment_planperson_payment_planprices1]
GO
ALTER TABLE [paymentdb].[soltura_planperson]  WITH CHECK ADD  CONSTRAINT [soltura_planperson$fk_payment_planperson_payment_schedules1] FOREIGN KEY([scheduleid])
REFERENCES [paymentdb].[soltura_schedules] ([scheduleid])
GO
ALTER TABLE [paymentdb].[soltura_planperson] CHECK CONSTRAINT [soltura_planperson$fk_payment_planperson_payment_schedules1]
GO
ALTER TABLE [paymentdb].[soltura_planperson_users]  WITH CHECK ADD  CONSTRAINT [soltura_planperson_users$fk_payment_planperson_has_payment_users_payment_planperson1] FOREIGN KEY([planpersonid])
REFERENCES [paymentdb].[soltura_planperson] ([planpersonid])
GO
ALTER TABLE [paymentdb].[soltura_planperson_users] CHECK CONSTRAINT [soltura_planperson_users$fk_payment_planperson_has_payment_users_payment_planperson1]
GO
ALTER TABLE [paymentdb].[soltura_planperson_users]  WITH CHECK ADD  CONSTRAINT [soltura_planperson_users$fk_payment_planperson_has_payment_users_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_planperson_users] CHECK CONSTRAINT [soltura_planperson_users$fk_payment_planperson_has_payment_users_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_planprices]  WITH CHECK ADD  CONSTRAINT [soltura_planprices$fk_payment_planprices_payment_currency1] FOREIGN KEY([currencyid])
REFERENCES [paymentdb].[soltura_currency] ([currencyid])
GO
ALTER TABLE [paymentdb].[soltura_planprices] CHECK CONSTRAINT [soltura_planprices$fk_payment_planprices_payment_currency1]
GO
ALTER TABLE [paymentdb].[soltura_planprices]  WITH CHECK ADD  CONSTRAINT [soltura_planprices$fk_payment_planprices_payment_subscriptions1] FOREIGN KEY([subscriptionid])
REFERENCES [paymentdb].[soltura_subscriptions] ([subscriptionid])
GO
ALTER TABLE [paymentdb].[soltura_planprices] CHECK CONSTRAINT [soltura_planprices$fk_payment_planprices_payment_subscriptions1]
GO
ALTER TABLE [paymentdb].[soltura_redemptions]  WITH CHECK ADD  CONSTRAINT [soltura_redemptions$fk_soltura_redemptions_soltura_benefits1] FOREIGN KEY([benefitsid])
REFERENCES [paymentdb].[soltura_benefits] ([benefitsid])
GO
ALTER TABLE [paymentdb].[soltura_redemptions] CHECK CONSTRAINT [soltura_redemptions$fk_soltura_redemptions_soltura_benefits1]
GO
ALTER TABLE [paymentdb].[soltura_redemptions]  WITH CHECK ADD  CONSTRAINT [soltura_redemptions$fk_soltura_redemptions_soltura_redemptionMethods1] FOREIGN KEY([redemptionMethodsid])
REFERENCES [paymentdb].[soltura_redemptionMethods] ([redemptionMethodsid])
GO
ALTER TABLE [paymentdb].[soltura_redemptions] CHECK CONSTRAINT [soltura_redemptions$fk_soltura_redemptions_soltura_redemptionMethods1]
GO
ALTER TABLE [paymentdb].[soltura_redemptions]  WITH CHECK ADD  CONSTRAINT [soltura_redemptions$fk_soltura_redemptions_soltura_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_redemptions] CHECK CONSTRAINT [soltura_redemptions$fk_soltura_redemptions_soltura_users1]
GO
ALTER TABLE [paymentdb].[soltura_rolespermission]  WITH CHECK ADD  CONSTRAINT [soltura_rolespermission$fk_payment_rolespermission_payment_permissions1] FOREIGN KEY([permissionid])
REFERENCES [paymentdb].[soltura_permissions] ([permissionid])
GO
ALTER TABLE [paymentdb].[soltura_rolespermission] CHECK CONSTRAINT [soltura_rolespermission$fk_payment_rolespermission_payment_permissions1]
GO
ALTER TABLE [paymentdb].[soltura_rolespermission]  WITH CHECK ADD  CONSTRAINT [soltura_rolespermission$fk_payment_rolespermission_payment_roles1] FOREIGN KEY([roleid])
REFERENCES [paymentdb].[soltura_roles] ([roleid])
GO
ALTER TABLE [paymentdb].[soltura_rolespermission] CHECK CONSTRAINT [soltura_rolespermission$fk_payment_rolespermission_payment_roles1]
GO
ALTER TABLE [paymentdb].[soltura_scheduledetails]  WITH CHECK ADD  CONSTRAINT [soltura_scheduledetails$fk_payment_scheduledetails_payment_schedules1] FOREIGN KEY([scheduleid])
REFERENCES [paymentdb].[soltura_schedules] ([scheduleid])
GO
ALTER TABLE [paymentdb].[soltura_scheduledetails] CHECK CONSTRAINT [soltura_scheduledetails$fk_payment_scheduledetails_payment_schedules1]
GO
ALTER TABLE [paymentdb].[soltura_states]  WITH CHECK ADD  CONSTRAINT [soltura_states$fk_payment_states_payment_countries1] FOREIGN KEY([countryid])
REFERENCES [paymentdb].[soltura_countries] ([countryid])
GO
ALTER TABLE [paymentdb].[soltura_states] CHECK CONSTRAINT [soltura_states$fk_payment_states_payment_countries1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_currency1] FOREIGN KEY([currencyid])
REFERENCES [paymentdb].[soltura_currency] ([currencyid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_currency1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_exchangerate1] FOREIGN KEY([exchangerateid])
REFERENCES [paymentdb].[soltura_exchangerate] ([exchangerateid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_exchangerate1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_payment1] FOREIGN KEY([paymentid])
REFERENCES [paymentdb].[soltura_payment] ([paymentid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_payment1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_schedules1] FOREIGN KEY([scheduleid])
REFERENCES [paymentdb].[soltura_schedules] ([scheduleid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_schedules1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_transsubtypes1] FOREIGN KEY([transsubtypesid])
REFERENCES [paymentdb].[soltura_transsubtypes] ([transsubtypesid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_transsubtypes1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_transtypes1] FOREIGN KEY([transtypeid])
REFERENCES [paymentdb].[soltura_transtypes] ([transtypeid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_payment_transactions_payment_transtypes1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_soltura_transactions_soltura_balances1] FOREIGN KEY([balanceid])
REFERENCES [paymentdb].[soltura_balances] ([balanceid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_soltura_transactions_soltura_balances1]
GO
ALTER TABLE [paymentdb].[soltura_transactions]  WITH CHECK ADD  CONSTRAINT [soltura_transactions$fk_soltura_transactions_soltura_funds1] FOREIGN KEY([fundid])
REFERENCES [paymentdb].[soltura_funds] ([fundid])
GO
ALTER TABLE [paymentdb].[soltura_transactions] CHECK CONSTRAINT [soltura_transactions$fk_soltura_transactions_soltura_funds1]
GO
ALTER TABLE [paymentdb].[soltura_translation]  WITH CHECK ADD  CONSTRAINT [soltura_translation$fk_payment_translation_payment_languages1] FOREIGN KEY([languagesid])
REFERENCES [paymentdb].[soltura_languages] ([languagesid])
GO
ALTER TABLE [paymentdb].[soltura_translation] CHECK CONSTRAINT [soltura_translation$fk_payment_translation_payment_languages1]
GO
ALTER TABLE [paymentdb].[soltura_translation]  WITH CHECK ADD  CONSTRAINT [soltura_translation$fk_payment_translation_payment_modules1] FOREIGN KEY([moduleid])
REFERENCES [paymentdb].[soltura_modules] ([moduleid])
GO
ALTER TABLE [paymentdb].[soltura_translation] CHECK CONSTRAINT [soltura_translation$fk_payment_translation_payment_modules1]
GO
ALTER TABLE [paymentdb].[soltura_useraddress]  WITH CHECK ADD  CONSTRAINT [soltura_useraddress$fk_payment_users_has_payment_addresses_payment_addresses1] FOREIGN KEY([addressid])
REFERENCES [paymentdb].[soltura_addresses] ([addressid])
GO
ALTER TABLE [paymentdb].[soltura_useraddress] CHECK CONSTRAINT [soltura_useraddress$fk_payment_users_has_payment_addresses_payment_addresses1]
GO
ALTER TABLE [paymentdb].[soltura_useraddress]  WITH CHECK ADD  CONSTRAINT [soltura_useraddress$fk_payment_users_has_payment_addresses_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_useraddress] CHECK CONSTRAINT [soltura_useraddress$fk_payment_users_has_payment_addresses_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_userinfo]  WITH CHECK ADD  CONSTRAINT [soltura_userinfo$fk_payment_userinfo_payment_paymentmethods1] FOREIGN KEY([methodid])
REFERENCES [paymentdb].[soltura_paymentmethods] ([methodid])
GO
ALTER TABLE [paymentdb].[soltura_userinfo] CHECK CONSTRAINT [soltura_userinfo$fk_payment_userinfo_payment_paymentmethods1]
GO
ALTER TABLE [paymentdb].[soltura_userinfo]  WITH CHECK ADD  CONSTRAINT [soltura_userinfo$fk_payment_userinfo_payment_userinfotypes1] FOREIGN KEY([userinfotypesid])
REFERENCES [paymentdb].[soltura_userinfotypes] ([userinfotypesid])
GO
ALTER TABLE [paymentdb].[soltura_userinfo] CHECK CONSTRAINT [soltura_userinfo$fk_payment_userinfo_payment_userinfotypes1]
GO
ALTER TABLE [paymentdb].[soltura_userinfo]  WITH CHECK ADD  CONSTRAINT [soltura_userinfo$fk_payment_userinfo_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_userinfo] CHECK CONSTRAINT [soltura_userinfo$fk_payment_userinfo_payment_users1]
GO
ALTER TABLE [paymentdb].[soltura_userpermissions]  WITH CHECK ADD  CONSTRAINT [soltura_userpermissions$fk_payment_userpermissions_payment_permissions1] FOREIGN KEY([permissionid])
REFERENCES [paymentdb].[soltura_permissions] ([permissionid])
GO
ALTER TABLE [paymentdb].[soltura_userpermissions] CHECK CONSTRAINT [soltura_userpermissions$fk_payment_userpermissions_payment_permissions1]
GO
ALTER TABLE [paymentdb].[soltura_userpermissions]  WITH CHECK ADD  CONSTRAINT [soltura_userpermissions$fk_payment_userpermissions_payment_users] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_userpermissions] CHECK CONSTRAINT [soltura_userpermissions$fk_payment_userpermissions_payment_users]
GO
ALTER TABLE [paymentdb].[soltura_usersroles]  WITH CHECK ADD  CONSTRAINT [soltura_usersroles$fk_payment_roles_has_payment_users_payment_roles1] FOREIGN KEY([roleid])
REFERENCES [paymentdb].[soltura_roles] ([roleid])
GO
ALTER TABLE [paymentdb].[soltura_usersroles] CHECK CONSTRAINT [soltura_usersroles$fk_payment_roles_has_payment_users_payment_roles1]
GO
ALTER TABLE [paymentdb].[soltura_usersroles]  WITH CHECK ADD  CONSTRAINT [soltura_usersroles$fk_payment_roles_has_payment_users_payment_users1] FOREIGN KEY([userid])
REFERENCES [paymentdb].[soltura_users] ([userid])
GO
ALTER TABLE [paymentdb].[soltura_usersroles] CHECK CONSTRAINT [soltura_usersroles$fk_payment_roles_has_payment_users_payment_users1]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'FUNCTION',@level1name=N'enum2str$soltura_schedules$endtype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'FUNCTION',@level1name=N'enum2str$soltura_schedules$recurrencytype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'FUNCTION',@level1name=N'norm_enum$soltura_schedules$endtype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'FUNCTION',@level1name=N'norm_enum$soltura_schedules$recurrencytype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'FUNCTION',@level1name=N'str2enum$soltura_schedules$endtype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'FUNCTION',@level1name=N'str2enum$soltura_schedules$recurrencytype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_addresses' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_addresses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_associatedCompanies' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_associatedCompanies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_authplatforms' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_authplatforms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_authsession' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_authsession'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_availablemethods' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_availablemethods'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_balances' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_balances'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_benefits' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_benefits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_benefitsquantity' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_benefitsquantity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_categorybenefits' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_categorybenefits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_cities' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_cities'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_companiesContactinfo' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_companiesContactinfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_companyinfotypes' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_companyinfotypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_contractDetails' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_contractDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_contracts' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_contracts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_countries' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_countries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_currency' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_currency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_exchangerate' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_exchangerate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_funds' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_funds'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_languages' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_languages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_logs' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_logs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_logseverity' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_logseverity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_logsources' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_logsources'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_logtypes' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_logtypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_mediafiles' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_mediafiles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_mediatypes' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_mediatypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_modules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_modules'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_payment' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_payment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_paymentmethods' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_paymentmethods'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_permissions' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_permissions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_planperson' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_planperson'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_planperson_users' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_planperson_users'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_planprices' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_planprices'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_redemptionMethods' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_redemptionMethods'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_redemptions' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_redemptions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_roles' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_roles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_rolespermission' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_rolespermission'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_scheduledetails' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_scheduledetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_schedules' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_schedules'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_states' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_states'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_subscriptions' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_subscriptions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_transactions' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_transactions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_translation' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_translation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_transsubtypes' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_transsubtypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_transtypes' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_transtypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_useraddress' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_useraddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_userinfo' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_userinfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_userinfotypes' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_userinfotypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_userpermissions' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_userpermissions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_users' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_users'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'paymentdb.soltura_usersroles' , @level0type=N'SCHEMA',@level0name=N'paymentdb', @level1type=N'TABLE',@level1name=N'soltura_usersroles'
GO
USE [master]
GO
ALTER DATABASE [solturadb] SET  READ_WRITE 
GO
