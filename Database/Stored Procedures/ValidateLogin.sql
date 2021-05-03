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