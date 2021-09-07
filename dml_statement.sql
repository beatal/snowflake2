--insert new value
insert into PUBLIC.STAGE_CUSTOMER values (37325400,'AAAAAAAAIPJIJDCA','Audrey','Haywood','Y',6,7,1955,'POLAND','','Audrey.H@rg.com',2452563);


--update exists value
update PUBLIC.STAGE_CUSTOMER set C_LAST_NAME = 'Smith'
where C_CUSTOMER_SK =37325304;


--delete one value from stage
delete from PUBLIC.STAGE_CUSTOMER where C_CUSTOMER_SK = 37325305;




