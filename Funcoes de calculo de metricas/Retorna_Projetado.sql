CREATE OR REPLACE FUNCTION Retorna_Projetado(projeto text) 
RETURNS TABLE ( janeiro double precision,fevereiro double precision,marco double precision,abril double precision,maio double precision,
               junho double precision,julho double precision,agosto double precision,setembro double precision,outubro double precision,
               novembro double precision,dezembro double precision) AS
$BODY$
DECLARE
	_name text;
    _query text:='SELECT';
     query_mes text;
    --_cursor CONSTANT refcursor := '_cursor';
BEGIN 
    FOR _name IN SELECT column_name FROM information_schema.Columns 
    WHERE table_schema = 'Fundiario' 
    AND table_name = 'Realizado'
    LOOP
    IF  _name<>'Projeto' THEN
        query_mes :='(100*( 
                            (SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('AREA_CODE')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 1')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 2')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 3')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 4')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 5')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 6')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 7')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 8')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            +(SELECT SUM("vstatus"/"dstatus") FROM Retorna_VSTATUS('||quote_literal('Sobreposicao 9')||','||quote_literal(projeto)||','||quote_literal(_name)||') AS A, Retorna_SOMA_DSTATUS('||quote_literal(projeto)||') AS B WHERE A."turbina"= B."turbina" )
                            )/(SELECT SUM(E."Peso") FROM "Fundiario"."PESO_FASE" AS E,"Fundiario"."Desenvolvimento_aero" AS A
                                WHERE  A."Turbina" Like '||quote_literal(CONCAT('%',projeto,'%'))||' 
                                AND SPLIT_PART(E."Projeto_Fase" , '||quote_literal('_')||', 2) = A."Fase"
                                AND SPLIT_PART(E."Projeto_Fase" , '||quote_literal('_')||', 1) = '||quote_literal(projeto)||')) As '||_name||',';
        _query:=CONCAT(_query,' ',query_mes);
        END IF;
        END LOOP;
_query=SUBSTRING(_query,1,length(_query)-1);
RETURN QUERY
EXECUTE _query;
END;
$BODY$

LANGUAGE 'plpgsql';


SELECT * FROM Retorna_Projetado('CUN');