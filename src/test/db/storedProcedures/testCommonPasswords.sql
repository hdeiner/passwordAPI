CREATE PROCEDURE [testSales].[test that there common_passwords table data is reasonable] AS
  BEGIN

    DECLARE @expectedCommonPasswordCount AS INT;
    SET @expectedCommonPasswordCount = 207;

    DECLARE @actualCommonPasswordCount AS INT;
    SELECT @actualCommonPasswordCount = Count(*) FROM common_passwords;

    EXEC tSQLt.AssertEquals @Expected = @expectedCommonPasswordCount, @Actual = @actualCommonPasswordCount,
          @Message = N'wrong number of common passwords';

    SET @expectedCommonPasswordCount = 1;

    SELECT @actualCommonPasswordCount = Count(*) FROM common_passwords WHERE name = N'welcome';

    EXEC tSQLt.AssertEquals @Expected = @expectedCommonPasswordCount, @Actual = @actualCommonPasswordCount,
          @Message = N'"welcome" should be a common password';

    SET @expectedCommonPasswordCount = 0;

    SELECT @actualCommonPasswordCount = Count(*) FROM common_passwords WHERE name = N'xyzzy';

    EXEC tSQLt.AssertEquals @Expected = @expectedCommonPasswordCount, @Actual = @actualCommonPasswordCount,
          @Message = N'"xyzzy" should not be a common password';

  END