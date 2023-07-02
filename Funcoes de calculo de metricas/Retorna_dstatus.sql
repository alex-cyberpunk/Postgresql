WHERE  A.'|| quote_ident(coluna) || ' = '|| quote_literal('Anm')|| ') THEN 1
ELSE 0
END 
AS Dtatus
FROM "Fundiario".'|| quote_ident(CONCAT(projeto,'_aero')) ||';';
END;
$BODY$
LANGUAGE 'plpgsql';

SELECT * FROM Retorna_DSTATUS('Sobreposicao 1','CUN')


CREATE OR REPLACE FUNCTION Retorna_SOMA_DSTATUS(projeto text) 
RETURNS TABLE ( Dstatus integer) AS
$BODY$
BEGIN
RETURN QUERY
EXECUTE
-- soma todos os dstatus da propriedades e sobreposicoes 
--por padrao substitui o valor dstatus nulo por um valor 1 , apenas para vstatus ser nulo
--pois por padrao se vstatus for nulo e esperado dstatus nulo 
'
SELECT (CAST(COALESCE(NULLIF(A."dstatus"+B."dstatus"+C."dstatus"+D."dstatus"+E."dstatus"+F."dstatus"+G."dstatus"+H."dstatus"+I."dstatus"+J."dstatus",0),'|| quote_literal('1') || ') AS INT))
 FROM  Retorna_DSTATUS('|| quote_literal('AREA_CODE')|| ','|| quote_literal(projeto) ||') AS A
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 1')|| ','|| quote_literal(projeto) ||') AS B
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 2')|| ','|| quote_literal(projeto) ||') AS C
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 3')|| ','|| quote_literal(projeto) ||') AS D
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 4')|| ','|| quote_literal(projeto) ||') AS E
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 5')|| ','|| quote_literal(projeto) ||') AS F
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 6')|| ','|| quote_literal(projeto) ||') AS G
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 7')|| ','|| quote_literal(projeto) ||') AS H
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 8')|| ','|| quote_literal(projeto) ||') AS I
 ,Retorna_DSTATUS('|| quote_literal('Sobreposicao 9')|| ','|| quote_literal(projeto) ||') AS J
 WHERE A."turbina"= B."turbina" AND B."turbina"=C."turbina" AND C."turbina"=D ."turbina" AND D."turbina"=E."turbina" AND E."turbina"=F."turbina" AND F."turbina"=G."turbina" AND F."turbina"=H."turbina" AND F."turbina"=I."turbina" AND F."turbina"=J."turbina"
';
END;
$BODY$
LANGUAGE 'plpgsql';

SELECT 
dstatus FROM Retorna_SOMA_DSTATUS('CUN') 
