USE [master]
GO

/****** Object:  Database [YearPlanner]    Script Date: 04/29/2021 11:24:51 AM ******/
CREATE DATABASE [YearPlanner]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'YearPlanner', FILENAME = N'D:\SQL\SQL\MSSQL14.BUENAVENTURA\MSSQL\DATA\YearPlanner.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'YearPlanner_log', FILENAME = N'D:\SQL\SQL\MSSQL14.BUENAVENTURA\MSSQL\DATA\YearPlanner_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [YearPlanner].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [YearPlanner] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [YearPlanner] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [YearPlanner] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [YearPlanner] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [YearPlanner] SET ARITHABORT OFF 
GO

ALTER DATABASE [YearPlanner] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [YearPlanner] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [YearPlanner] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [YearPlanner] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [YearPlanner] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [YearPlanner] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [YearPlanner] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [YearPlanner] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [YearPlanner] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [YearPlanner] SET  DISABLE_BROKER 
GO

ALTER DATABASE [YearPlanner] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [YearPlanner] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [YearPlanner] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [YearPlanner] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [YearPlanner] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [YearPlanner] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [YearPlanner] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [YearPlanner] SET RECOVERY FULL 
GO

ALTER DATABASE [YearPlanner] SET  MULTI_USER 
GO

ALTER DATABASE [YearPlanner] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [YearPlanner] SET DB_CHAINING OFF 
GO

ALTER DATABASE [YearPlanner] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [YearPlanner] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [YearPlanner] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [YearPlanner] SET QUERY_STORE = OFF
GO

ALTER DATABASE [YearPlanner] SET  READ_WRITE 
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[Email_Table]    Script Date: 04/30/2021 11:59:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Email_Table](
	[EmailID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](200) NOT NULL,
 CONSTRAINT [PK_Email_Table] PRIMARY KEY CLUSTERED 
(
	[EmailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[Event_Table]    Script Date: 04/30/2021 11:59:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Event_Table](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[UserID_FK] [int] NOT NULL,
	[RepetitionID_FK] [int] NOT NULL,
	[EventTitle] [varchar](200) NOT NULL,
	[EventDescription] [varchar](max) NULL,
	[EventDate] [date] NOT NULL,
	[EventStartTime] [time](7) NOT NULL,
	[EventEndTime] [time](7) NOT NULL,
	[EventOriginalFlag] [bit] NOT NULL,
 CONSTRAINT [PK_Event_Table] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Event_Table]  WITH CHECK ADD  CONSTRAINT [FK_Event_Table_Repetition_Table] FOREIGN KEY([RepetitionID_FK])
REFERENCES [dbo].[Repetition_Table] ([RepetitionID])
GO

ALTER TABLE [dbo].[Event_Table] CHECK CONSTRAINT [FK_Event_Table_Repetition_Table]
GO

ALTER TABLE [dbo].[Event_Table]  WITH CHECK ADD  CONSTRAINT [FK_Event_Table_User_Table] FOREIGN KEY([UserID_FK])
REFERENCES [dbo].[User_Table] ([UserID])
GO

ALTER TABLE [dbo].[Event_Table] CHECK CONSTRAINT [FK_Event_Table_User_Table]
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[Gender_Table]    Script Date: 04/30/2021 11:59:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Gender_Table](
	[GenderID] [int] IDENTITY(1,1) NOT NULL,
	[GenderType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Gender_Table] PRIMARY KEY CLUSTERED 
(
	[GenderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[Objective_Table]    Script Date: 04/30/2021 12:00:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Objective_Table](
	[ObjectiveID] [int] IDENTITY(1,1) NOT NULL,
	[UserID_FK] [int] NOT NULL,
	[RepetitionID_FK] [int] NOT NULL,
	[ObjectiveTitle] [varchar](100) NOT NULL,
	[ObjectiveDescription] [varchar](max) NOT NULL,
	[ObjectiveOriginalFlag] [bit] NOT NULL,
 CONSTRAINT [PK_Objective_Table] PRIMARY KEY CLUSTERED 
(
	[ObjectiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Objective_Table]  WITH CHECK ADD  CONSTRAINT [FK_Objective_Table_Repetition_Table] FOREIGN KEY([RepetitionID_FK])
REFERENCES [dbo].[Repetition_Table] ([RepetitionID])
GO

ALTER TABLE [dbo].[Objective_Table] CHECK CONSTRAINT [FK_Objective_Table_Repetition_Table]
GO

ALTER TABLE [dbo].[Objective_Table]  WITH CHECK ADD  CONSTRAINT [FK_Objective_Table_User_Table] FOREIGN KEY([UserID_FK])
REFERENCES [dbo].[User_Table] ([UserID])
GO

ALTER TABLE [dbo].[Objective_Table] CHECK CONSTRAINT [FK_Objective_Table_User_Table]
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[ObjectiveLog_Table]    Script Date: 04/30/2021 12:00:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ObjectiveLog_Table](
	[ObjectiveLogID] [int] IDENTITY(1,1) NOT NULL,
	[ObjectiveID_FK] [int] NOT NULL,
	[UserID_FK] [int] NOT NULL,
	[ObjectiveLogDate] [date] NOT NULL,
	[ObjectiveLogStatus] [bit] NOT NULL,
 CONSTRAINT [PK_ObjectiveLog_Table] PRIMARY KEY CLUSTERED 
(
	[ObjectiveLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectiveLog_Table]  WITH CHECK ADD  CONSTRAINT [FK_ObjectiveLog_Table_Objective_Table] FOREIGN KEY([ObjectiveID_FK])
REFERENCES [dbo].[Objective_Table] ([ObjectiveID])
GO

ALTER TABLE [dbo].[ObjectiveLog_Table] CHECK CONSTRAINT [FK_ObjectiveLog_Table_Objective_Table]
GO

ALTER TABLE [dbo].[ObjectiveLog_Table]  WITH CHECK ADD  CONSTRAINT [FK_ObjectiveLog_Table_User_Table] FOREIGN KEY([UserID_FK])
REFERENCES [dbo].[User_Table] ([UserID])
GO

ALTER TABLE [dbo].[ObjectiveLog_Table] CHECK CONSTRAINT [FK_ObjectiveLog_Table_User_Table]
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[Repetition_Table]    Script Date: 04/30/2021 12:00:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Repetition_Table](
	[RepetitionID] [int] IDENTITY(1,1) NOT NULL,
	[RepetitionType] [varchar](100) NOT NULL,
	[RepetitionDescription] [varchar](200) NULL,
 CONSTRAINT [PK_Repetition_Table] PRIMARY KEY CLUSTERED 
(
	[RepetitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ====================
USE [YearPlanner]
GO

/****** Object:  Table [dbo].[User_Table]    Script Date: 04/30/2021 12:00:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[User_Table](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[EmailID_FK] [int] NOT NULL,
	[GenderID_FK] [int] NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](100) NOT NULL,
	[Password] [varchar](200) NOT NULL,
	[Birthday] [date] NOT NULL,
 CONSTRAINT [PK_User_Table] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[User_Table]  WITH CHECK ADD  CONSTRAINT [FK_User_Table_Email_Table] FOREIGN KEY([EmailID_FK])
REFERENCES [dbo].[Email_Table] ([EmailID])
GO

ALTER TABLE [dbo].[User_Table] CHECK CONSTRAINT [FK_User_Table_Email_Table]
GO

ALTER TABLE [dbo].[User_Table]  WITH CHECK ADD  CONSTRAINT [FK_User_Table_User_Table] FOREIGN KEY([GenderID_FK])
REFERENCES [dbo].[Gender_Table] ([GenderID])
GO

ALTER TABLE [dbo].[User_Table] CHECK CONSTRAINT [FK_User_Table_User_Table]
GO