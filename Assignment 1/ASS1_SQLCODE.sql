create or replace PROCEDURE ADD_CUST_TO_DB (pcustid number, pcustname varchar2) AS
Out_Of_Range Exception;
BEGIN 
IF pcustid <1 OR pcustid >499 THEN
RAISE Out_Of_Range;
END IF;
INSERT INTO customer (custid, custname, SALES_YTD, STATUS)
VALUES (pcustid, pcustname, 0, 'OK');

EXCEPTION
WHEN DUP_VAL_ON_iNDEX THEN
raise_application_error(-20010,	'Duplicate customer ID');

WHEN Out_Of_Range THEN
raise_application_error(-20002,	'Customer ID	out	of	range');

WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/
create or replace PROCEDURE ADD_CUSTOMER_VIASQLDEV (pcustid number, pcustname varchar2) AS
BEGIN

dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Adding Customer ID: ' || pcustid || ' Name: ' || pcustname);

ADD_CUST_TO_DB(pcustid, pcustname);
dbms_output.put_line('Customer Added Ok');
EXCEPTION

WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;
/
create or replace PROCEDURE ADD_LOCATION_TO_DB(ploccode varchar2, pminqty number, pmaxqty number) AS
CHECK_LOCID_LENGTH EXCEPTION;
CHECK_MAXQTY_GREATER_MIXQTY EXCEPTION;
CHECK_MINQTY_RANGE EXCEPTION;
CHECK_MAXQTY_RANGE EXCEPTION;
BEGIN
IF Length(PLOCCODE) <> 5 THEN
RAISE CHECK_LOCID_LENGTH;
END IF;
IF PMAXQTY < PMINQTY THEN
RAISE CHECK_MAXQTY_GREATER_MIXQTY;
END IF;
IF PMINQTY <0 OR PMINQTY >999 THEN
RAISE CHECK_MINQTY_RANGE;
END IF; 
IF PMAXQTY <0 OR PMAXQTY >999 THEN
RAISE CHECK_MAXQTY_RANGE;
END IF; 
INSERT INTO LOCATION(LOCID, MINQTY, MAXQTY)
VALUES (PLOCCODE, PMINQTY, PMAXQTY);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
raise_application_error(-20081,	'Duplicate location ID');
WHEN CHECK_LOCID_LENGTH THEN
raise_application_error(-20082, ' Location Code length invalid');
WHEN CHECK_MAXQTY_GREATER_MIXQTY THEN
raise_application_error(-20086, 'Minimum qty larger than maximum qty');
WHEN CHECK_MINQTY_RANGE THEN
raise_application_error(-20083, 'Minimum Qty out of range');
WHEN CHECK_MAXQTY_RANGE THEN
raise_application_error(-20084, 'Maximum Qty out of range');
WHEN OTHERS THEN 
dbms_output.put_line(SQLERRM);
END;





/
create or replace PROCEDURE ADD_LOCATION_VIASQLDEV (ploccode varchar2, pminqty number, pmaxqty number) AS
BEGIN

dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Adding Location LocCode: ' || ploccode || ' MinQty: ' || pminqty || ' MaxQty: ' || pmaxqty);

ADD_LOCATION_TO_DB(ploccode, pminqty, pmaxqty);
EXCEPTION
WHEN OTHERS THEN 
dbms_output.put_line(SQLERRM);


END;



/
create or replace PROCEDURE ADD_PROD_TO_DB(pprodid number, pprodname varchar2, pprice number) AS
ID_Out_Of_Range Exception;
Price_Out_Of_Range Exception;
BEGIN
IF pprodid <1000 OR pprodid >2500 THEN
RAISE ID_Out_Of_Range;
END IF;
IF pprice <0 OR pprice >999.99 THEN
RAISE Price_Out_Of_Range;
END IF;
INSERT INTO product (prodid, prodname, selling_price, SALES_YTD)
VALUES (pprodid, pprodname, pprice, 0);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
raise_application_error(-20010,	'Duplicate Product ID');

WHEN ID_Out_Of_Range THEN
raise_application_error(-20012,	'Product ID	out	of	range');

WHEN Price_Out_Of_Range THEN
raise_application_error(-20013,	'Price out	of	range');

WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');

END;
/
create or replace PROCEDURE ADD_PRODUCT_VIASQLDEV(pprodid number, pprodname varchar2, pprice number) AS
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Adding Product ID: ' || pprodid || ' Name: ' || pprodname || ' Price: ' || pprice);
ADD_PROD_TO_DB(pprodid, pprodname, pprice);
EXCEPTION
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;

/
create or replace PROCEDURE ADD_SIMPLE_SALE_TO_DB (pcustid number, pprodid number, pqty number) AS
Out_Of_Range Exception;
NO_UPD_ERR EXCEPTION;
BEGIN
IF pqty <1 OR pqty >999 THEN
RAISE Out_Of_Range;
END IF;
IF SQL%ROWCOUNT = 0 THEN
RAISE NO_UPD_ERR;
END IF;
EXCEPTION 
WHEN NO_UPD_ERR THEN
raise_application_error(-20061,	'Product ID not found');
WHEN Out_Of_Range THEN
raise_application_error(-20071, 'Sales quantity outside valid range');
WHEN NO_DATA_FOUND THEN
raise_application_error(-20073, 'Customer ID not found');
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;

/
create or replace PROCEDURE ADD_SIMPLE_SALE_VIASQLDEV (pcustid number, pprodid number, pqty number) AS

BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Adding simple sale. Customer ID: ' || pcustid || ' Product ID: ' || pprodid || ' Quantity: ' || pqty );
ADD_SIMPLE_SALE_TO_DB(pcustid, pprodid, pqty);
EXCEPTION 
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;

/
create or replace PROCEDURE DELETE_ALL_CUSTOMERS_VIASQLDEV AS
j number;
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Deleting all customer rows');
j := DELETE_ALL_CUSTOMERS_FROM_DB;
dbms_output.put_line('Number of customers deleted: ' || to_char(j));
EXCEPTION
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;

/
create or replace PROCEDURE DELETE_ALL_PRODUCTS_VIASQLDEV AS
y number;
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Deleting all product rows');
y := DELETE_ALL_PRODUCTS_FROM_DB;
dbms_output.put_line('Number of products deleted: ' || to_char(y));
EXCEPTION
WHEN OTHERS THEN 
dbms_output.put_line('Use value of sqlerrm');
END;
/
create or replace PROCEDURE GET_ALLCUST_VIASQLDEV AS
RV_SYSREFCUR  SYS_REFCURSOR;
CUSREC  CUSTOMER%ROWTYPE;
BEGIN
dbms_output.put_line('Listing all customer details');
RV_SYSREFCUR := GET_ALLCUST;
LOOP
FETCH RV_SYSREFCUR INTO CUSREC;
EXIT WHEN RV_SYSREFCUR%NOTFOUND;
dbms_output.put_line('--------------------------------------------');

dbms_output.put_line('Customer ID: ' || CUSREC.CUSTID || ' Name: ' || CUSREC.custname || ' Status ' || CUSREC.status || ' SalesYTD ' || CUSREC.Sales_YTD);
END LOOP;
EXCEPTION
WHEN OTHERS THEN 
dbms_output.put_line('Use value of sqlerrm');
END;
/
create or replace PROCEDURE GET_ALLPROD_VIASQLDEV AS
RV_SYSREFCUR  SYS_REFCURSOR;
PRODREC  PRODUCT%ROWTYPE;
BEGIN
dbms_output.put_line('Listing all product details');
RV_SYSREFCUR := GET_ALLPROD_FROM_DB;
LOOP
FETCH RV_SYSREFCUR INTO PRODREC;
EXIT WHEN RV_SYSREFCUR%NOTFOUND;
dbms_output.put_line('--------------------------------------------');

dbms_output.put_line('Product ID: ' || PRODREC.prodid || ' Name: ' || PRODREC.prodname || ' Price ' || PRODREC.selling_price || ' SalesYTD ' || PRODREC.Sales_YTD);
END LOOP;
EXCEPTION
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;
/
create or replace PROCEDURE GET_CUST_STRING_VIASQLDEV (pcustid number) AS
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Getting details for customer ID: ' || GET_CUST_STRING_FROM_DB(pcustid));
EXCEPTION 
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;
/
create or replace PROCEDURE GET_PROD_STRING_VIASQLDEV (pprodid number) AS
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Getting details for customer ID: ' || GET_PROD_STRING_FROM_DB(pprodid));
EXCEPTION 
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;
/
create or replace PROCEDURE SUM_CUST_SALES_VIASQLDEV AS
q number;
BEGIN

dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Summing customer salesYTD');
q := SUM_CUST_SALESYTD;
dbms_output.put_line('All customer total: ' || to_char(q));

EXCEPTION


WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;
/
create or replace PROCEDURE SUM_PROD_SALES_VIASQLDEV AS
q number;
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Summing product salesYTD');
q := SUM_PROD_SALESYTD_FROM_DB;
dbms_output.put_line('All product total: ' || to_char(q));
EXCEPTION
WHEN NO_DATA_FOUND THEN
dbms_output.put_line(SQLCODE);
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;
/
create or replace PROCEDURE UPD_CUST_SALESYTD_IN_DB (pcustid number, pamt number) AS
Out_Of_Range Exception;
NO_UPD_ERR EXCEPTION;
BEGIN
IF pamt <-999.99 OR pamt >999.99 THEN
RAISE Out_Of_Range;
END IF;
UPDATE CUSTOMER
SET SALES_YTD = SALES_YTD + pamt
WHERE CUSTID = pcustid;
IF SQL%ROWCOUNT = 0 THEN
RAISE NO_UPD_ERR;
END IF;


EXCEPTION 
WHEN NO_UPD_ERR THEN
raise_application_error(-20021,	'Customer ID not found');
WHEN Out_Of_Range THEN
raise_application_error(-20032,	'Amount	out	of	range');
WHEN OTHERS THEN 
raise_application_error(-20000, SQLERRM);
END;

/
create or replace PROCEDURE UPD_CUST_SALESYTD_VIASQLDEV (pcustid number, pamt number) AS
BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Updating SalesYTD. Customer ID: ' || pcustid || ' Amount: ' || pamt);

UPD_CUST_SALESYTD_IN_DB(pcustid, pamt);

EXCEPTION 
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;

/
create or replace PROCEDURE UPD_CUST_STATUS_IN_DB (pcustid number, pstatus varchar2) AS
NO_UPD_ERR EXCEPTION;
INVALID_STATUS EXCEPTION;
BEGIN
UPDATE CUSTOMER
SET STATUS = pstatus
WHERE CUSTID = pcustid;
IF SQL%ROWCOUNT = 0 THEN
RAISE NO_UPD_ERR;
END IF;

IF pstatus not in ('Ok', 'Not ok') then
RAISE INVALID_STATUS; 
END IF;

EXCEPTION 
WHEN INVALID_STATUS THEN
raise_application_error(-20062,	'Invalid Status Value');
WHEN NO_UPD_ERR THEN
raise_application_error(-20061,	'Customer ID not found');
WHEN OTHERS THEN 
raise_application_error(-20000, SQLERRM);
END;
/
create or replace PROCEDURE UPD_CUST_STATUS_VIASQLDEV (pcustid number, pstatus varchar2) AS

BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Updating status. ID: ' || pcustid || ' New Status ' || pstatus);
UPD_CUST_STATUS_IN_DB(pcustid, pstatus);
EXCEPTION 

WHEN OTHERS THEN 
dbms_output.put_line(SQLERRM);
END;

/
create or replace PROCEDURE UPD_PROD_SALESYTD_IN_DB (pprodid number, pamt number) AS
Out_Of_Range Exception;
NO_UPD_ERR EXCEPTION;
BEGIN
IF pamt <-999.99 OR pamt >999.99 THEN
RAISE Out_Of_Range;
END IF;
UPDATE PRODUCT
SET SALES_YTD = SALES_YTD + pamt
WHERE PRODID = pprodid;
IF SQL%ROWCOUNT = 0 THEN
RAISE NO_UPD_ERR;
END IF;

EXCEPTION 
WHEN NO_UPD_ERR THEN
raise_application_error(-20041,	'Product ID not found');
WHEN Out_Of_Range THEN
raise_application_error(-20052, 'Amount	out	of	range');
WHEN OTHERS THEN 
raise_application_error(-20000, SQLERRM);
END;
/
create or replace PROCEDURE UPD_PROD_SALESYTD_VIASQLDEV (pprodid number, pamt number) AS

BEGIN
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('Updating SalesYTD. Product ID: ' || pprodid || ' Amount ' || pamt);
UPD_PROD_SALESYTD_IN_DB(pprodid, pamt);
UPD_PROD_SALESYTD_IN_DB (pprodid, pamt);
EXCEPTION 
WHEN OTHERS THEN 
dbms_output.put_line(SQLCODE);
END;

/
create or replace FUNCTION DELETE_ALL_CUSTOMERS_FROM_DB RETURN NUMBER AS
BEGIN
DELETE FROM CUSTOMER;
return sql%rowcount;
EXCEPTION
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/
create or replace FUNCTION DELETE_ALL_PRODUCTS_FROM_DB RETURN NUMBER AS
BEGIN
DELETE FROM Product;
return sql%rowcount;
EXCEPTION
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/
create or replace FUNCTION GET_ALLCUST RETURN SYS_REFCURSOR AS
RV_SYSREFCUR  SYS_REFCURSOR;
BEGIN
OPEN RV_SYSREFCUR FOR SELECT * FROM CUSTOMER;
RETURN RV_SYSREFCUR;
EXCEPTION
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/
create or replace FUNCTION GET_ALLPROD_FROM_DB RETURN SYS_REFCURSOR AS
RV_SYSREFCUR  SYS_REFCURSOR;
BEGIN
OPEN RV_SYSREFCUR FOR SELECT * FROM PRODUCT;
RETURN RV_SYSREFCUR;
EXCEPTION
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/
create or replace function GET_ALLSALES_FROM_DB return sys_refcursor as
      Vcur Sys_Refcursor;
    begin
      OPEN VcUR FOR SELECT * FROM SALE WHERE SALEID = 50000;
      RETURN VCUR;
    exception
      WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
    End; 
/
create or replace FUNCTION GET_CUST_STRING_FROM_DB (pcustid number) RETURN VARCHAR2 AS
  VCUSTNAME VARCHAR2(100);
  VSALES_YTD NUMBER;
  VSTATUS VARCHAR2(7);
  r VARCHAR2(1000);
  UPD_ERROR EXCEPTION;
BEGIN
  SELECT max( 'Customer ID: ' || pcustid || 'Name: ' || Vcustname || 'Status: ' || VStatus || 'SalesYTD: ' || VSales_YTD ) into r
  FROM CUSTOMER
  WHERE CUSTID = PCUSTID;

     if r is null then 
       RAISE UPD_ERROR;
     else
         RETURN r;
     end if;

EXCEPTION 
WHEN UPD_ERROR THEN
raise_application_error(-20021, 'Customer ID not found');
WHEN OTHERS THEN 
raise_application_error(-20000, SQLERRM);
END;




/
create or replace FUNCTION GET_PROD_STRING_FROM_DB (pprodid number) RETURN VARCHAR2 AS
  VPRODNAME VARCHAR2(100);
  VSELLING_PRICE NUMBER;
  VSALES_YTD NUMBER;
  r VARCHAR2(1000);
  UPD_ERROR EXCEPTION;
BEGIN
  SELECT max( 'Product ID: ' || pprodid || 'Product Name: ' || VPRODNAME || 'Selling Price: ' || VSELLING_PRICE || 'SalesYTD: ' || VSales_YTD ) into r
  FROM PRODUCT
  WHERE PRODID = PPRODID;
     if r is null then 
       RAISE UPD_ERROR;
     else
         RETURN r;
     end if;

EXCEPTION 
WHEN UPD_ERROR THEN
    raise_application_error(-20041, 'Product ID not found');
  WHEN OTHERS THEN 
    raise_application_error(-20000, SQLERRM);
END;


/
create or replace FUNCTION SUM_CUST_SALESYTD RETURN NUMBER AS
total NUMBER;
BEGIN 
SELECT SUM(sales_ytd)INTO TOTAL FROM CUSTOMER;
RETURN total;
EXCEPTION
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/
create or replace FUNCTION SUM_PROD_SALESYTD_FROM_DB RETURN NUMBER AS
total NUMBER;
BEGIN 
SELECT SUM(sales_ytd)INTO TOTAL FROM PRODUCT;
RETURN total;
EXCEPTION
WHEN OTHERS THEN 
raise_application_error(-20000, 'Use value of sqlerrm');
END;
/



