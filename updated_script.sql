USE [master]
GO

/****** Object:  Database [solturadb]    Script Date: 13/4/2025 16:42:45 ******/
CREATE DATABASE [solturadb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'solturadb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\solturadb.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'solturadb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\solturadb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
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

ALTER DATABASE [solturadb] SET QUERY_STORE = ON
GO

ALTER DATABASE [solturadb] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO

ALTER DATABASE [solturadb] SET  READ_WRITE 
GO

