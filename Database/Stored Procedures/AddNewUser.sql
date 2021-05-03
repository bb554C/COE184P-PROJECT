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