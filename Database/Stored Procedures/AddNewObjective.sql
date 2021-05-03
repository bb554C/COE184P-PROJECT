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