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