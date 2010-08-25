EXEC tSQLt.NewTestClass 'tSQLt_test_TableToText';
GO
--[skip]
CREATE PROC tSQLt_test_TableToText.[xtest TableToText returns NULL if table does not exist]
AS
BEGIN
    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = 'DoesNotExist';
   
    EXEC tSQLt.AssertEqualsString NULL, @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText works for one column #table]
AS
BEGIN
    SELECT *
      INTO #DoesExist
      FROM (SELECT 1) AS x(y);

    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist';
   
    EXEC tSQLt.AssertEqualsString '|y|
+-+
|1|', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText works for one TEXT column #table]
AS
BEGIN
    CREATE TABLE #DoesExist(
      T TEXT
    );
    INSERT INTO #DoesExist (T)VALUES('This is my text value');
    
    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist';
   
    EXEC tSQLt.AssertEqualsString '|T                    |
+---------------------+
|This is my text value|', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText works for one DATETIME column #table]
AS
BEGIN
    CREATE TABLE #DoesExist(
      T DATETIME
    );
    INSERT INTO #DoesExist (T)VALUES('2001-10-13T12:34:56.787');
    
    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist';
   
    EXEC tSQLt.AssertEqualsString '|T                      |
+-----------------------+
|2001-10-13 12:34:56.787|', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText works for one VARBINARY(MAX) column #table]
AS
BEGIN
    CREATE TABLE #DoesExist(
      T VARBINARY(MAX)
    );
    INSERT INTO #DoesExist (T)VALUES(0xfedcba9876543210);
    
    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist';
   
    EXEC tSQLt.AssertEqualsString '|T                 |
+------------------+
|0xfedcba9876543210|', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText works for one column #table with several rows]
AS
BEGIN
    SELECT no
      INTO #DoesExist
      FROM tSQLt.f_Num(4);

    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist';
   
    EXEC tSQLt.AssertEqualsString '|no|
+--+
|1 |
|2 |
|3 |
|4 |', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText orders by @orderBy]
AS
BEGIN
    SELECT no
      INTO #DoesExist
      FROM tSQLt.f_Num(4);

    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist', @OrderBy = '10-no+10*(no%2)';
   
    EXEC tSQLt.AssertEqualsString '|no|
+--+
|4 |
|2 |
|3 |
|1 |', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText with no rows]
AS
BEGIN
    SELECT no
      INTO #DoesExist
      FROM tSQLt.f_Num(0);

    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist';
   
    EXEC tSQLt.AssertEqualsString '|no|
+--+', @result;
END;
GO

CREATE PROC tSQLt_test_TableToText.[test TableToText with several columns and rows]
AS
BEGIN
    SELECT no, 10-no AS FromTen, NULL AS NullCol
      INTO #DoesExist
      FROM tSQLt.f_Num(4);

    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist', @OrderBy = 'no';
   
    EXEC tSQLt.AssertEqualsString '|no|FromTen|NullCol|
+--+-------+-------+
|1 |9      |!NULL! |
|2 |8      |!NULL! |
|3 |7      |!NULL! |
|4 |6      |!NULL! |', @result;
END;
GO
CREATE PROC tSQLt_test_TableToText.[test TableToText with 100 columns]
AS
BEGIN
/*
DECLARE @n INT; SET @n = 100;
DECLARE @cols VARCHAR(MAX);
SET @cols = STUFF((
SELECT ','+CAST(no AS VARCHAR(MAX))+'+no AS C'+RIGHT(CAST(no+100000 AS VARCHAR(MAX)),LEN(CAST(@n AS VARCHAR(MAX))))
FROM tSQLt.f_Num(@n)
FOR XML PATH('')
),1,1,'')
PRINT @cols;
--*/
    SELECT 1+no AS C001,2+no AS C002,3+no AS C003,4+no AS C004,5+no AS C005,6+no AS C006,7+no AS C007,8+no AS C008,9+no AS C009,10+no AS C010,11+no AS C011,12+no AS C012,13+no AS C013,14+no AS C014,15+no AS C015,16+no AS C016,17+no AS C017,18+no AS C018,19+no AS C019,20+no AS C020,21+no AS C021,22+no AS C022,23+no AS C023,24+no AS C024,25+no AS C025,26+no AS C026,27+no AS C027,28+no AS C028,29+no AS C029,30+no AS C030,31+no AS C031,32+no AS C032,33+no AS C033,34+no AS C034,35+no AS C035,36+no AS C036,37+no AS C037,38+no AS C038,39+no AS C039,40+no AS C040,41+no AS C041,42+no AS C042,43+no AS C043,44+no AS C044,45+no AS C045,46+no AS C046,47+no AS C047,48+no AS C048,49+no AS C049,50+no AS C050,51+no AS C051,52+no AS C052,53+no AS C053,54+no AS C054,55+no AS C055,56+no AS C056,57+no AS C057,58+no AS C058,59+no AS C059,60+no AS C060,61+no AS C061,62+no AS C062,63+no AS C063,64+no AS C064,65+no AS C065,66+no AS C066,67+no AS C067,68+no AS C068,69+no AS C069,70+no AS C070,71+no AS C071,72+no AS C072,73+no AS C073,74+no AS C074,75+no AS C075,76+no AS C076,77+no AS C077,78+no AS C078,79+no AS C079,80+no AS C080,81+no AS C081,82+no AS C082,83+no AS C083,84+no AS C084,85+no AS C085,86+no AS C086,87+no AS C087,88+no AS C088,89+no AS C089,90+no AS C090,91+no AS C091,92+no AS C092,93+no AS C093,94+no AS C094,95+no AS C095,96+no AS C096,97+no AS C097,98+no AS C098,99+no AS C099,100+no AS C100
      INTO #DoesExist
      FROM tSQLt.f_Num(4);

    DECLARE @result NVARCHAR(MAX);
    EXEC tSQLt.TableToText @txt = @result OUT, @TableName = '#DoesExist', @OrderBy = 'C001';
   
    EXEC tSQLt.AssertEqualsString '|C001|C002|C003|C004|C005|C006|C007|C008|C009|C010|C011|C012|C013|C014|C015|C016|C017|C018|C019|C020|C021|C022|C023|C024|C025|C026|C027|C028|C029|C030|C031|C032|C033|C034|C035|C036|C037|C038|C039|C040|C041|C042|C043|C044|C045|C046|C047|C048|C049|C050|C051|C052|C053|C054|C055|C056|C057|C058|C059|C060|C061|C062|C063|C064|C065|C066|C067|C068|C069|C070|C071|C072|C073|C074|C075|C076|C077|C078|C079|C080|C081|C082|C083|C084|C085|C086|C087|C088|C089|C090|C091|C092|C093|C094|C095|C096|C097|C098|C099|C100|
+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
|2   |3   |4   |5   |6   |7   |8   |9   |10  |11  |12  |13  |14  |15  |16  |17  |18  |19  |20  |21  |22  |23  |24  |25  |26  |27  |28  |29  |30  |31  |32  |33  |34  |35  |36  |37  |38  |39  |40  |41  |42  |43  |44  |45  |46  |47  |48  |49  |50  |51  |52  |53  |54  |55  |56  |57  |58  |59  |60  |61  |62  |63  |64  |65  |66  |67  |68  |69  |70  |71  |72  |73  |74  |75  |76  |77  |78  |79  |80  |81  |82  |83  |84  |85  |86  |87  |88  |89  |90  |91  |92  |93  |94  |95  |96  |97  |98  |99  |100 |101 |
|3   |4   |5   |6   |7   |8   |9   |10  |11  |12  |13  |14  |15  |16  |17  |18  |19  |20  |21  |22  |23  |24  |25  |26  |27  |28  |29  |30  |31  |32  |33  |34  |35  |36  |37  |38  |39  |40  |41  |42  |43  |44  |45  |46  |47  |48  |49  |50  |51  |52  |53  |54  |55  |56  |57  |58  |59  |60  |61  |62  |63  |64  |65  |66  |67  |68  |69  |70  |71  |72  |73  |74  |75  |76  |77  |78  |79  |80  |81  |82  |83  |84  |85  |86  |87  |88  |89  |90  |91  |92  |93  |94  |95  |96  |97  |98  |99  |100 |101 |102 |
|4   |5   |6   |7   |8   |9   |10  |11  |12  |13  |14  |15  |16  |17  |18  |19  |20  |21  |22  |23  |24  |25  |26  |27  |28  |29  |30  |31  |32  |33  |34  |35  |36  |37  |38  |39  |40  |41  |42  |43  |44  |45  |46  |47  |48  |49  |50  |51  |52  |53  |54  |55  |56  |57  |58  |59  |60  |61  |62  |63  |64  |65  |66  |67  |68  |69  |70  |71  |72  |73  |74  |75  |76  |77  |78  |79  |80  |81  |82  |83  |84  |85  |86  |87  |88  |89  |90  |91  |92  |93  |94  |95  |96  |97  |98  |99  |100 |101 |102 |103 |
|5   |6   |7   |8   |9   |10  |11  |12  |13  |14  |15  |16  |17  |18  |19  |20  |21  |22  |23  |24  |25  |26  |27  |28  |29  |30  |31  |32  |33  |34  |35  |36  |37  |38  |39  |40  |41  |42  |43  |44  |45  |46  |47  |48  |49  |50  |51  |52  |53  |54  |55  |56  |57  |58  |59  |60  |61  |62  |63  |64  |65  |66  |67  |68  |69  |70  |71  |72  |73  |74  |75  |76  |77  |78  |79  |80  |81  |82  |83  |84  |85  |86  |87  |88  |89  |90  |91  |92  |93  |94  |95  |96  |97  |98  |99  |100 |101 |102 |103 |104 |', @result;
END;
GO



EXEC tSQLt.Run 'tSQLt_test_TableToText';
