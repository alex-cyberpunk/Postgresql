CREATE OR REPLACE FUNCTION Retorna_VSTATUS(coluna text,projeto text,mes text) 
RETURNS TABLE ( Turbina character varying ,Vstatus double precision) AS
$BODY$
DECLARE
    _query text;
     query_mapeamento text;
     query_anm text;
     query_inutilizado text;
BEGIN

_query:='(SELECT 
A."Turbina",D."Pontuacao"*E."Peso"
FROM "Fundiario"."PESO_FASE" AS E,  "Fundiario"."Desenvolvimento_aero" AS A
INNER JOIN "Fundiario"."Desenvolvimento_area" B ON B."AREA_CODE" = A.'||quote_ident(coluna)||'
INNER JOIN "Fundiario"."Criterio" D ON D."Status Fundiario" = B.'||quote_ident(CONCAT('Situacao do imovel  ',mes))||'
WHERE  A."Turbina" Like ' ||quote_literal(CONCAT('%',projeto,'%'))||'
AND SPLIT_PART(E."Projeto_Fase" , '|| quote_literal('_')|| ' , 2) = A."Fase" 
AND SPLIT_PART(E."Projeto_Fase" , '|| quote_literal('_')|| ', 1) = '||quote_literal(projeto)||')';

query_inutilizado='UNION
(SELECT A."Turbina", 
CAST(COALESCE(NULLIF(B."Proprietario principal",'||quote_literal('Inutilizado')||'),'||quote_literal('0')||' ) AS DECIMAL(10,2)) 
FROM "Fundiario"."Desenvolvimento_aero" AS A
INNER JOIN "Fundiario"."Desenvolvimento_area" B ON B."AREA_CODE" = A.'||quote_ident(coluna)||'
WHERE A."Turbina" like '||quote_literal(CONCAT('%',projeto,'%'))||' 
and B."Proprietario principal"  like '||quote_literal('%Inutilizado%')||')';

_query = CONCAT(_query,' ',query_inutilizado);
IF coluna = 'AREA_CODE' THEN 
    query_mapeamento:='UNION 
    (SELECT A."Turbina" ,D."Pontuacao"*E."Peso" FROM "Fundiario"."PESO_FASE" AS E, "Fundiario"."Desenvolvimento_aero" AS A 
    INNER JOIN "Fundiario"."Desenvolvimento_mapeamento" AS C ON  C."Turbina" = A."Turbina" 
    INNER JOIN "Fundiario"."Criterio" D ON D."Status Fundiario" = C.'||quote_ident(CONCAT('Situacao ',mes))||'
    WHERE  A."Turbina" Like ' ||quote_literal(CONCAT('%',projeto,'%'))||'
    AND SPLIT_PART(E."Projeto_Fase" , '|| quote_literal('_')|| ', 2) = A."Fase" 
    AND SPLIT_PART(E."Projeto_Fase" , '|| quote_literal('_')|| ', 1) = '||quote_literal(projeto)||' 
    AND A."AREA_CODE" IS NULL)';
_query = CONCAT(_query,' ',query_mapeamento);
ELSE 
    query_anm:='UNION 
    (SELECT A."Turbina", CAST(COALESCE(NULLIF('||quote_ident(coluna)|| ','||quote_literal('Anm')||'),'||quote_literal('0')||' ) AS DECIMAL(10,2)) 
    FROM "Fundiario"."Desenvolvimento_aero" AS A  
    WHERE  A."Turbina" Like ' ||quote_literal(CONCAT('%',projeto,'%'))||' AND('||quote_ident(coluna)|| ' IS NULL OR '||quote_ident(coluna)|| ' = '||quote_literal('Anm')||') )';
_query = CONCAT(_query,' ',query_anm);
END IF;
_query = CONCAT(_query,' ',' ORDER BY 1 ');
RETURN QUERY
EXECUTE _query;
END;
$BODY$

LANGUAGE 'plpgsql';

SELECT * FROM Retorna_VSTATUS('Sobreposicao 1','VES','set')