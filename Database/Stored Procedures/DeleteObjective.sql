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