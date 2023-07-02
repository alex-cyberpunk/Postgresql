CREATE OR REPLACE FUNCTION Aeros_regularizados_mensal(mes text) 
RETURNS TABLE ( Turbina character varying ,mensal integer) AS
$BODY$
DECLARE
	_name text;
    _query text;
    query_mes text;
   
BEGIN 
    FOR _name IN SELECT column_name FROM information_schema.Columns 
    WHERE table_schema = 'Fundiario' 
    AND table_name = 'Desenvolvimento_aero'
    LOOP
    IF  _name<>'Turbina' AND _name<>'Projeto' AND _name<>'Fase' THEN
        IF _name<>'AREA_CODE' THEN
            query_mes :=' (SELECT  "Turbina",
                    CASE
                    WHEN "Turbina" IN (SELECT 
                    A."Turbina"
                    FROM "Fundiario"."Desenvolvimento_aero" AS A
                    INNER JOIN "Fundiario"."Desenvolvimento_area" B ON B."AREA_CODE" = A.'||quote_ident(_name)||'
                    INNER JOIN "Fundiario"."Criterio" D ON D."Status Fundiario" = B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||'
                    WHERE B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||' = '||quote_literal('Regularizado')||'  
                    OR B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||' = '||quote_literal('Regularizado Padrão Internacional')||'  
                    OR B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||' = '||quote_literal('Áreas CTG')||'
                    ORDER BY A."Turbina") THEN 1
                    WHEN '||quote_ident(_name)||' IS NULL THEN 1
                    ELSE  0
                    END 
                    AS '||quote_ident(mes)||'
                    FROM "Fundiario"."Desenvolvimento_aero")
                    INTERSECT';
            ELSE 
                query_mes :=' (SELECT  "Turbina",
                    CASE
                    WHEN "Turbina" IN (SELECT 
                    A."Turbina"
                    FROM "Fundiario"."Desenvolvimento_aero" AS A
                    INNER JOIN "Fundiario"."Desenvolvimento_area" B ON B."AREA_CODE" = A.'||quote_ident(_name)||'
                    INNER JOIN "Fundiario"."Criterio" D ON D."Status Fundiario" = B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||'
                    WHERE B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||' = '||quote_literal('Regularizado')||'  
                    OR B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||' = '||quote_literal('Regularizado Padrão Internacional')||'
                    OR B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||' = '||quote_literal('Áreas CTG')||'
                    ORDER BY A."Turbina") THEN 1
                    WHEN '||quote_ident(_name)||' IS NULL THEN 0
                    WHEN "Turbina" in (SELECT "Turbina" FROM "Fundiario"."Desenvolvimento_mapeamento") THEN 0
                    ELSE  0
                    END 
                    AS '||quote_ident(mes)||'
                    FROM "Fundiario"."Desenvolvimento_aero")
                    INTERSECT';
            END IF;
        _query:=CONCAT(_query,' ',query_mes);
        END IF;
        END LOOP;
_query=SUBSTRING(_query,1,length(_query)-10);
_query=CONCAT(_query,'ORDER BY "Turbina" ;');