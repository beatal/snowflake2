--set TIMESTAMP_OF_CHANGE= current_timestamp;
set TIMESTAMP_OF_CHANGE =TO_TIMESTAMP('2021-08-26T00:00:00.000');


merge into PUBLIC.TARGET_CUSTOMER tc
    using (select SC.*,  NVL(SC.C_CUSTOMER_SK, TC.C_CUSTOMER_SK) CUST_ID 
            from PUBLIC.STAGE_CUSTOMER SC full outer join PUBLIC.TARGET_CUSTOMER TC
            on TC.C_CUSTOMER_SK = SC.C_CUSTOMER_SK) ALL_CUST
    on ALL_CUST.CUST_ID = TC.C_CUSTOMER_SK
    and TC.C_END_DATE = TO_TIMESTAMP('9999-12-31T00:00:00.000')
--when row changed
    when matched and (ALL_CUST.C_FIRST_NAME !=TC.C_FIRST_NAME 
                    OR ALL_CUST.C_LAST_NAME!=TC.C_LAST_NAME 
                    OR ALL_CUST.C_PREFERRED_CUST_FLAG!=TC.C_PREFERRED_CUST_FLAG
                    OR ALL_CUST.C_EMAIL_ADDRESS != tc.C_EMAIL_ADDRESS) 
                                                                        then update set C_END_DATE = $TIMESTAMP_OF_CHANGE
--when row from source was deleted    
    when matched and ALL_CUST.C_CUSTOMER_SK is null then update set C_END_DATE = $TIMESTAMP_OF_CHANGE
--when not exists in tgt
    when not matched then insert (C_CUSTOMER_SK
                                , C_CUSTOMER_ID
                                , C_FIRST_NAME
                                , C_LAST_NAME
                                , C_PREFERRED_CUST_FLAG
                                , C_BIRTH_DAY
                                , C_BIRTH_MONTH
                                , C_BIRTH_YEAR
                                , C_BIRTH_COUNTRY
                                , C_LOGIN
                                , C_EMAIL_ADDRESS
                                , C_LAST_REVIEW_DATE
                                , C_START_DATE
                                , C_END_DATE)
                            values (ALL_CUST.C_CUSTOMER_SK
                                , ALL_CUST.C_CUSTOMER_ID
                                , ALL_CUST.C_FIRST_NAME
                                , ALL_CUST.C_LAST_NAME
                                , ALL_CUST.C_PREFERRED_CUST_FLAG
                                , ALL_CUST.C_BIRTH_DAY
                                , ALL_CUST.C_BIRTH_MONTH
                                , ALL_CUST.C_BIRTH_YEAR
                                , ALL_CUST.C_BIRTH_COUNTRY
                                , ALL_CUST.C_LOGIN
                                , ALL_CUST.C_EMAIL_ADDRESS
                                , ALL_CUST.C_LAST_REVIEW_DATE
                                , $TIMESTAMP_OF_CHANGE
                                , to_timestamp('9999-12-31T00:00:00.000'));




merge into PUBLIC.TARGET_CUSTOMER TC
    using PUBLIC.STAGE_CUSTOMER SC 
    on  (TC.C_CUSTOMER_SK = SC.C_CUSTOMER_SK 
        and SC.C_FIRST_NAME =TC.C_FIRST_NAME 
        and SC.C_LAST_NAME = TC.C_LAST_NAME 
        and SC.C_PREFERRED_CUST_FLAG = TC.C_PREFERRED_CUST_FLAG
        and SC.C_EMAIL_ADDRESS = TC.C_EMAIL_ADDRESS)

--insert when row was updated
    when not matched then insert (C_CUSTOMER_SK
                                , C_CUSTOMER_ID
                                , C_FIRST_NAME
                                , C_LAST_NAME
                                , C_PREFERRED_CUST_FLAG
                                , C_BIRTH_DAY
                                , C_BIRTH_MONTH
                                , C_BIRTH_YEAR
                                , C_BIRTH_COUNTRY
                                , C_LOGIN
                                , C_EMAIL_ADDRESS
                                , C_LAST_REVIEW_DATE
                                , C_START_DATE
                                , C_END_DATE)
                            values (SC.C_CUSTOMER_SK
                                , SC.C_CUSTOMER_ID
                                , SC.C_FIRST_NAME
                                , SC.C_LAST_NAME
                                , SC.C_PREFERRED_CUST_FLAG
                                , SC.C_BIRTH_DAY
                                , SC.C_BIRTH_MONTH
                                , SC.C_BIRTH_YEAR
                                , SC.C_BIRTH_COUNTRY
                                , SC.C_LOGIN
                                , SC.C_EMAIL_ADDRESS
                                , SC.C_LAST_REVIEW_DATE
                                , $TIMESTAMP_OF_CHANGE
                                , to_timestamp('9999-12-31T00:00:00.000'));
