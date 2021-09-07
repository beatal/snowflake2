CREATE or replace PROCEDURE db_beata.public.add_column_into_table(TABLE_NAME VARCHAR,COLUMN_NAME VARCHAR, COLUMN_TYPE VARCHAR)
  RETURNS VARCHAR
  LANGUAGE javascript
  AS
  $$
  try {
    var if_command = `select count(*) from information_schema.tables where table_name = '${TABLE_NAME}'`;
    var if_stmt = snowflake.createStatement( {sqlText: if_command});
    var if_result = if_stmt.execute();
        if_result.next();
    var row_count = if_result.getColumnValue(1);

    if (row_count != 0) 
       {
       var if_command2 = `select count(*) from information_schema.columns where table_name = '${TABLE_NAME}' and column_name = '${COLUMN_NAME}'`;
       var if_stmt2 = snowflake.createStatement( {sqlText: if_command2});
       var if_result2 = if_stmt2.execute();
       if_result2.next();
       var row_count2 = if_result2.getColumnValue(1);

       if (row_count2 == 0) 
           {
           var sql_command3 = 'ALTER TABLE '+ TABLE_NAME +' ADD COLUMN '+ COLUMN_NAME +' ' + COLUMN_TYPE; 
           var stmt3 = snowflake.createStatement( {sqlText: sql_command3} ); 
           var resultSet3 = stmt3.execute(); 
           return 'Success'
           }
        else
           {return 'Column already exists'}
       
       }
    else
        {
       return 'Table not available'}
  }
  catch(error) {
  console.error(error);
  return 'error'
  }
  $$;