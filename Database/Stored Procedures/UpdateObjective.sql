SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE UpdateObjective
	@ObjectiveID int,
	@UserID_FK int,
	@RepetitionType varchar(100),
	@PriorityType varchar(100),
	@ObjectiveTitle varchar(100),
	@ObjectiveDescription varchar(MAX),
	@ObjectiveDate date
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RepetitionID_FK int, @PriorityID_FK int;

	SELECT @RepetitionID_FK = RT.RepetitionID
	FROM Repetition_Table AS RT
	WHERE RT.RepetitionType = @RepetitionType

	SELECT @PriorityID_FK = PT.PriorityID
	FROM Priority_Table AS PT
	WHERE PT.PriorityType = @PriorityType

	UPDATE Objective_Table
	SET RepetitionID_FK = @RepetitionID_FK,
		PriorityID_FK = @PriorityID_FK,
		ObjectiveTitle = @ObjectiveTitle,
		ObjectiveDescription = @ObjectiveDescription,
		ObjectiveDate = @ObjectiveDate
	WHERE ObjectiveID = @ObjectiveID AND UserID_FK = @UserID_FK
END
GO