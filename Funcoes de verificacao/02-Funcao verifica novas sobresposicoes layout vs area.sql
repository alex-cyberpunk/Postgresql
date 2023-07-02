CREATE OR REPLACE FUNCTION sobreposicoes_layout_base(data_desejada text) 
RETURNS TABLE ( aero_code varchar,  area_code varchar ) AS
$BODY$
DECLARE
   rec   record;
   sri integer:=Find_SRID('Historico_layout', 'BRE_layout_2022-2022-07-06', 'geom');
BEGIN
   FOR rec IN
      SELECT *
      FROM   pg_tables
      WHERE  tablename NOT LIKE 'pg\_%' AND schemaname = 'Bases'
      ORDER  BY tablename
   LOOP
      IF Find_SRID('Historico_layout', CONCAT(rec.tablename,'_layout_2022','-',data_desejada), 'geom') <> 4326 THEN
      RETURN QUERY
      EXECUTE
          'SELECT a.aero_code,b.area_code
          FROM "Historico_layout".'||quote_ident(CONCAT(rec.tablename,'_layout_2022','-',data_desejada))|| 'a, "Historico_bases".'||quote_ident(CONCAT(rec.tablename,'-',data_desejada))||' b
          WHERE  ST_INTERSECTS(ST_Transform(ST_PointOnSurface(a.geom),4326), b.geom); ';
      ELSE
        RETURN QUERY
        EXECUTE
          'SELECT a.aero_code,b.area_code
          FROM "Historico_layout".'||quote_ident(CONCAT(rec.tablename,'_layout_2022','-',data_desejada))|| 'a, "Historico_bases".'||quote_ident(CONCAT(rec.tablename,'-',data_desejada))||' b
          WHERE  ST_INTERSECTS(ST_PointOnSurface(a.geom), b.geom); ';
      END IF;
    END LOOP; 
END;
$BODY$
LANGUAGE 'plpgsql';


SELECT * FROM sobreposicoes_layout_base('2022-07-06') 