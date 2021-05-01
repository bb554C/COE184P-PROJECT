-- USER TABLE
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddNewUser
	@Email varchar(200),
	@GenderID_FK int,
	@FirstName varchar(100),
	@LastName varchar(100),
	@Password varchar(200),
	@Birthday date
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Email_Table(Email_Table.Email)
	VALUES (@Email)
	
	declare @EmailIDtemp int;

	SELECT @EmailIDtemp = ET.EmailID
	FROM Email_Table AS ET WHERE ET.Email = @Email

	INSERT INTO User_Table(EmailID_FK, GenderID_FK, FirstName, LastName, User_Table.Password, Birthday) 
	VALUES (@EmailIDtemp, @GenderID_FK, @FirstName, @LastName, @Password, @Birthday)
END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ValidateLogin
	@Email varchar(200),
	@Password varchar(200)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT UT.UserID
	FROM User_Table AS UT
	FULL OUTER JOIN Email_Table AS ET
	ON UT.EmailID_FK = ET.EmailID
	WHERE UT.Password = @Password AND ET.Email = @Email
END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE GetFullUserInfo
	@UserID int,
AS
BEGIN
	SET NOCOUNT ON;
	SELECT UT.FirstName, UT.LastName, GT.GenderType, UT.Birthday, ET.Email
	FROM User_Table AS UT
	FULL OUTER JOIN Email_Table AS ET
	ON UT.EmailID_FK = ET.EmailID
	FULL OUTER JOIN Gender_Table AS GT
	ON UT.GenderID_FK = GT.GenderID
	WHERE UT.UserID = @UserID
END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE UpdateUser
	@UserID int,
	@GenderID_FK int,
	@FirstName varchar(100),
	@LastName varchar(100),
	@Password varchar(200),
	@Birthday date
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE User_Table
	SET User_Table.FirstName = @FirstName,
		User_Table.LastName = @LastName,
		User_Table.Password = @Password,
		User_Table.Birthday = @Birthday
	WHERE User_Table.UserID = @UserID
END
GO
-- GENDER TABLE
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE GetGenderType
AS
BEGIN
	SELECT GT.GenderType
	FROM Gender_Table AS GT
END
GO
-- EVENT TABLE
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddNewEvent
	@UserID_FK int,
	@RepititionType varchar(100),
	@EventTitle varchar(200),
	@EventDescription varchar(MAX),
	@EventDate date,
	@EventStartTime time,
	@EventEndTime time
AS
BEGIN
	SET NOCOUNT ON;
	declare @RepetitionID_FK int;
	
	SELECT @RepetitionID_FK = RT.RepetitionID
	FROM Repetition_Table AS RT
	WHERE RT.RepetitionType = @RepititionType

	INSERT INTO Event_Table(UserID_FK, RepetitionID_FK, EventTitle, EventDescription, EventDate, EventStartTime, EventEndTime, EventOriginalFlag)
	VALUES (@UserID_FK, @RepetitionID_FK, @EventTitle, @EventDescription, @EventDate, @EventStartTime, @EventEndTime, '1')
END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE UpdateEvent
	@EventID int,
	@UserID_FK int,
	@RepetitionID_FK int,
	@PriorityID_FK int,
	@EventTitle varchar(100),
	@EventDescription varchar(MAX),
	@EventDate date,
	@EventStartTime time,
	@EventEndTime time
AS
BEGIN
	SET NOCOUNT ON;
	declare @RepetitionID_FK int, @PriorityID_FK int;

	SELECT @RepetitionID_FK = RT.RepetitionID
	FROM Repetition_Table AS RT
	WHERE RT.RepetitionType = @RepetitionType

	SELECT @PriorityID_FK = PT.PriorityID
	FROM Priority_Table AS PT
	WHERE PT.PriorityType = @PriorityType

	UPDATE Event_Table
	SET RepetitionID_FK = @RepetitionID_FK,
		PriorityID_FK = @PriorityID_FK,
		EventTitle = @EventTitle,
		EventDescription = @EventDescription,
		EventDate = @EventDate,
		EventStartTime = @EventStartTime,
		EventEndTime = @EventEndTime
	WHERE EventID = @EventID AND UserID_FK = @UserID_FK
END
GO

-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeleteEvent
	@UserID_FK int,
	@EventID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM Event_Table WHERE Event_Table.EventID = @EventID AND Event_Table.UserID_FK = @UserID_FK
END
GO

-- OBJECTIVE TABLE
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddNewObjective
	@UserID_FK int,
	@RepetitionType varchar(100),
	@PriorityType varchar(100),
	@ObjectiveTitle varchar(100),
	@ObjectiveDescription varchar(MAX),
	@ObjectiveDate date,
	@ObjectiveOriginalFlag bit
AS
BEGIN
	SET NOCOUNT ON;
	declare  @RepetitionID_FK int, @PriorityID_FK int, @ObjectiveID_FK int;

	SELECT @RepetitionID_FK = RT.RepetitionID
	FROM Repetition_Table AS RT
	WHERE RT.RepetitionType = @RepetitionType

	SELECT @PriorityID_FK = PT.PriorityID
	FROM Priority_Table AS PT
	WHERE PT.PriorityType = @PriorityType

	INSERT INTO Objective_Table(UserID_FK, RepetitionID_FK, PriorityID_FK, ObjectiveTitle, ObjectiveDescription, ObjectiveDate, ObjectiveOriginalFlag)
	VALUES (@UserID_FK, @RepetitionID_FK, @PriorityID_FK, @ObjectiveTitle, @ObjectiveDescription, @ObjectiveDate, '1')

	SELECT @ObjectiveID_FK = OT.ObjectiveID
	FROM Objective_Table AS OT
	WHERE OT.ObjectiveTitle = @ObjectiveTitle AND OT.ObjectiveOriginalFlag = '1' AND OT.UserID_FK = @UserID_FK

	INSERT INTO ObjectiveLog_Table(ObjectiveID_FK, UserID_FK, ObjectiveLogDate, ObjectiveLogStatus)
	VALUES (@ObjectiveID_FK, @UserID_FK, @ObjectiveDate, '0')
END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE UpdateObjectiveLog
	@ObjectiveID_FK int,
	@UserID_FK int,
	@ObjectiveLogDate date,
	@ObjectiveStatus bit
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE ObjectiveLog_Table
	SET ObjectiveLogDate = @ObjectiveLogDate,
		ObjectiveLogStatus = @ObjectiveStatus
	WHERE ObjectiveID_FK = @ObjectiveID_FK AND UserID_FK = @UserID_FK AND ObjectiveLogDate = @ObjectiveLogDate
END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeleteObjective
	@ObjectiveID int,
	@UserID_FK int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM ObjectiveLog_Table 
	WHERE ObjectiveLog_Table.ObjectiveID_FK = @ObjectiveID AND ObjectiveLog_Table.UserID_FK = @UserID_FK
	DELETE FROM Objective_Table 
	WHERE Objective_Table.ObjectiveID = @ObjectiveID AND Objective_Table.UserID_FK = @UserID_FK

END
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE UpdateObjective
	@ObjectiveID int,
	@UserID_FK int,
	@RepetitionID_FK int,
	@PriorityID_FK int,
	@ObjectiveTitle varchar(100),
	@ObjectiveDescription varchar(MAX),
	@ObjectiveDate date
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Objective_Table
	SET RepetitionID_FK = @RepetitionID_FK,
		PriorityID_FK = @PriorityID_FK,
		ObjectiveTitle = @ObjectiveTitle,
		ObjectiveDescription = @ObjectiveDescription,
		ObjectiveDate = @ObjectiveDate
	WHERE ObjectiveID = @ObjectiveID AND UserID_FK = @UserID_FK
END
GO
