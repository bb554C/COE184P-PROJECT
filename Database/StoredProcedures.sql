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

	SELECT EmailIDtemp = ET.EmailID
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

