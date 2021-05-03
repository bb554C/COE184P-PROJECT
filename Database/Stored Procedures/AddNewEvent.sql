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