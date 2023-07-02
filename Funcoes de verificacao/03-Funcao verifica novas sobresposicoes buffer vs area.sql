CREATE OR REPLACE FUNCTION sobreposicoes_buffer_base(data_desejada text) 
RETURNS TABLE ( aero_code varchar,  area_code varchar ) AS
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
   IF Find_SRID('Historico_layout', CONCAT(rec.tablename,'_layout_2022','-',data_desejada), 'geom') <> 4326 THEN
      RETURN QUERY
      EXECUTE
      'SELECT a.aero_code,b.area_code
      FROM "Historico_layout".'||quote_ident(CONCAT(rec.tablename,'_layout_2022','-',data_desejada))|| 'a, "Historico_bases".'||quote_ident(CONCAT(rec.tablename,'-',data_desejada))||' b
      WHERE  ST_INTERSECTS(ST_Buffer(ST_Transform(a.geom,4326)::geography,85)::geometry, b.geom); ';
    ELSE
        RETURN QUERY
        EXECUTE
        'SELECT a.aero_code,b.area_code
      FROM "Historico_layout".'||quote_ident(CONCAT(rec.tablename,'_layout_2022','-',data_desejada))|| 'a, "Historico_bases".'||quote_ident(CONCAT(rec.tablename,'-',data_desejada))||' b
      WHERE  ST_INTERSECTS(ST_Buffer(a.geom::geography,85)::geometry, b.geom); ';
      END IF;
    END LOOP; 
END;
$BODY$
LANGUAGE 'plpgsql';

SELECT CONCAT(aero_code,'-',area_code) FROM sobreposicoes_buffer_base('2022-08-09')
EXCEPT 
SELECT CONCAT(aero_code,'-',area_code) FROM sobreposicoes_buffer_base('2022-07-06')


$Esse except compara os pares de colunas retornando se uma area anm agora esta mapeada e as edicoes que afetaram
os buffers de aeros nesse periodo$