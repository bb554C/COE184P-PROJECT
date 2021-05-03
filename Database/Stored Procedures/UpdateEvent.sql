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