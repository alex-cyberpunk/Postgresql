CREATE OR REPLACE FUNCTION areas_novas(data_inicio text,data_fim text) 
RETURNS TABLE ( column_list varchar ) AS
$BODY$
DECLARE
   rec   record;
BEGIN
   FOR rec IN
      SELECT *
      FROM   pg_tables
      WHERE  tablename NOT LIKE 'pg\_%' AND schemaname = 'Bases'
      ORDER  BY tablename
   LOOP
      RETURN QUERY
      EXECUTE 'SELECT area_code
         FROM "Historico_bases".' || quote_ident(CONCAT(rec.tablename,'-',data_inicio))|| 'EXCEPT 
         SELECT area_code FROM "Historico_bases".'
        || quote_ident(CONCAT(rec.tablename,'-',data_fim))||';' ;
   END LOOP;
END;
$BODY$
LANGUAGE 'plpgsql';

Surgiram
SELECT * FROM areas_novas ('2022-08-03','2022-06-07') 
Sumiram
SELECT * FROM areas_novas ('2022-06-07','2022-08-03')