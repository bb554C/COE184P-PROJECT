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