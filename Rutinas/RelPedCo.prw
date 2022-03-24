#Include 'Protheus.ch'                                                                      
#Include 'Topconn.ch'

#define PAD_LEFT 	0
#define PAD_RIGHT 	1
#define PAD_CENTER 	2


////////////////////////////////////////////////////////////////////////////////////////////
// Impressão do Relatório																  //
////////////////////////////////////////////////////////////////////////////////////////////
User Function RelPedCo(cNumero, cClifor, cLoja, cNome,dData)

Private cIdioma 		:= __LANGUAGE
Private cTitulo			:= if(cIdioma == "SPANISH","Conferencia de Rastreabilidad / Orden de Ventas",if(cIdioma == "ENGLISH","Report by Sales Request","Relatório por Pedido de Venda")) 
Private cMens 			:= if(cIdioma == "SPANISH","No hay registros para los parámetros informados !",if(cIdioma == "ENGLISH","There are no records for the reported parameters !","Não há registros para os parametros informados !"))
Private nPag			:= 1
Private nLin   			:= 9000
Private oFont1 			:= TFont():New("Arial",09,14,		,.T.,,,,,.F.)
Private oFont2  		:= TFont():New("Arial",09,09,		,.F.,,,,,.F.)
Private oFont2N  		:= TFont():New("Arial",09,09,		,.T.,,,,,.F.)
Private oFont3  		:= TFont():New("Arial",10,10,.T.	,.T.,,,,,.F.)
Private oFont4  		:= TFont():New("Arial",12,12,.T.   	,.T.,,,,,.F.)
Private oFont5  		:= TFont():New("Arial",13,13,   	,.F.,,,,,.F.)
Private oPrint 			:= TMSPrinter():New(cTitulo)

Private PixelX 		:= oPrint:nLogPixelX()
Private PixelY 		:= oPrint:nLogPixelY()

Private nCol1	:= 50		
Private nCol2	:= nCol1 + 500  
Private nCol3	:= nCol2 + 900
Private nCol4	:= nCol3 + 400
Private nCol5	:= nCol4 + 400


cNumero	:= padr(cNumero,tamSx3("C6_NUM")[1])
cClifor	:= padr(cClifor,tamSx3("A1_COD")[1])
cLoja	:= padr(cLoja,tamSx3("A1_LOJA")[1])


RunRel(cTitulo,cMens,cNumero, cClifor, cLoja, cNome,dData)
 
oPrint:Preview()

Return

                                 
************************************************************************************************************************************
//Impressão do Relatório
************************************************************************************************************************************
Static Function RunRel(cTitulo,cMens,cNumero, cClifor, cLoja, cNome, dData)
             
local lPrivez	:= .t.             
Local cQuery	:= ""
Local cAlias	:= getNextAlias()
Local cMensProc	:= if(cIdioma == "SPANISH","Imprimiendo Producto: ",if(cIdioma == "ENGLISH","Printing Product: ","Imprimindo Produto: "))
Local cMensRoda	:= if(cIdioma == "SPANISH","Continuación...",if(cIdioma == "ENGLISH","To be continued...","Continua..."))
Local cDescric	:= ""
Local nQtdPedido:= 0


If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf
             
cQuery:= " SELECT ZZH_COD, COUNT(ZZH_COD) ZZH_QTD "+CRLF //, ZZH_LOTE
cQuery+= " FROM " + CRLF
cQuery+=   RetSqlName("ZZH")+"  " + CRLF
cQuery+= " WHERE ZZH_PEDIDO = '"+ cNumero +"' "+CRLF
cQuery+= " AND ZZH_CLIENT = '"+ cClifor +"' "+CRLF
cQuery+= " AND ZZH_LOJAC = '"+ cLoja +"' "+CRLF
cQuery+= " AND D_E_L_E_T_ = '' "+CRLF
cQuery+= " GROUP BY ZZH_COD "+CRLF //, ZZH_LOTE       

TcQuery cQuery new alias (cAlias)


(cAlias)->(dbGoTop())

oPrint:SetPortrait() 

While !(cAlias)->(Eof())

	IncProc( cMensProc + Alltrim((cAlias)->ZZH_COD ))
    
	if nLin >= 2300
		if !lPriVez
			nLin+=40
			oPrint:Say(nLin,0020,Replicate("_",300)	,oFont2)
			nLin+=50                                            
			oPrint:Say(nLin,nCol1	,cMensRoda	,oFont2)
			lPrivez:= .f.
		endif
		
		oPrint:EndPage()
		ImpCabec(cTitulo,cNumero, cClifor, cLoja, cNome, dData )	
		
   	endif                       
	
	cDescric:= Posicione("SB1",1,xFilial("SB1")+(cAlias)->ZZH_COD,"B1_DESC")
	if Empty(cDescric)
		cDescric:= "**** No hay registro **** "
	endif	
	
	
	dbSelectArea("SC6")
	SC6->(dbSetOrder(2))
	if SC6->(dbSeek(xFilial("SC6")+(cAlias)->ZZH_COD+cNumero))
		nQtdPedido:= SC6->C6_QTDVEN
	endif	
	
	//nQtdPedido:= fBuscaPed(cNumero,(cAlias)->ZZH_COD,(cAlias)->ZZH_LOTE)

	oPrint:Say(nLin,nCol1 , Alltrim((cAlias)->ZZH_COD)						,oFont2)
	oPrint:Say(nLin,nCol2 , Alltrim(cDescric)								,oFont2)
	//oPrint:Say(nLin,nCol3 , Alltrim((cAlias)->ZZH_LOTE)						,oFont2)
	oPrint:Say(nLin,nCol3 , Transform((cAlias)->ZZH_QTD ,"@E 99999")			,oFont2,,,,PAD_RIGHT)			
	oPrint:Say(nLin,nCol4 , Transform(nQtdPedido ,"@E 99999")					,oFont2,,,,PAD_RIGHT)			
	
	nLin+= 60
			
	nQtdNota:= 0
	
	(cAlias)->(dbSkip())		
enddo

Return 




/*///////////////////////////////////////////////////////////////////////////////////////////////
//Impressão do Cabeçalho                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////*/
Static Function ImpCabec(cTitulo,cNumero, cClifor, cLoja, cNome, dData)
                                                                                                             
Local cPagina	:= if(cIdioma == "SPANISH","página: ",if(cIdioma == "ENGLISH","Page: ","Página: "))                                                                                                             
Local cEmissao	:= if(cIdioma == "SPANISH","emisión: ",if(cIdioma == "ENGLISH","Emission: ","Emissão: "))
                                                                                                             
Local cCabec1	:= if(cIdioma == "SPANISH","Pedido de Venta: ",if(cIdioma == "ENGLISH","Sales order: ","Pedido de Venda: "))
Local cCabec2	:= if(cIdioma == "SPANISH","Emisión: ",if(cIdioma == "ENGLISH","Emission: ","Emissão: "))
Local cCabec3	:= if(cIdioma == "SPANISH","Cliente: ",if(cIdioma == "ENGLISH","Client: ","Cliente: "))

Local cColuna1	:= if(cIdioma == "SPANISH","Producto",if(cIdioma == "ENGLISH","Product","Produto"))
Local cColuna2	:= if(cIdioma == "SPANISH","Descripción",if(cIdioma == "ENGLISH","Description","Descrição"))
Local cColuna3	:= if(cIdioma == "SPANISH","Lote",if(cIdioma == "ENGLISH","Lot","Lote"))
Local cColuna4	:= if(cIdioma == "SPANISH","Qtd. Lida",if(cIdioma == "ENGLISH","Qtd. Read","Qtd. Lida"))
Local cColuna5	:= if(cIdioma == "SPANISH","Qtd. solicitud",if(cIdioma == "ENGLISH","Qtd. Order","Qtd. Pedido"))

nLin := 12
If nPag != 1
	oPrint:EndPage()
EndIf             

oPrint:StartPage()

nLin+=050
oPrint:SayBitmap(nLin, 050, "lgrl01.bmp", 0200, 0200)
oPrint:Say(nLin,0800, cTitulo			,oFont5)
oPrint:Say(nLin,3280,cPagina + StrZero(nPag,3)				,oFont2,,,,PAD_RIGHT)
nLin+=050
oPrint:Say(nLin,3280,cEmissao + DtoC(dDatabase)				,oFont2,,,,PAD_RIGHT)
nLin += 100
oPrint:Say(nLin,020,Replicate("_",300)	,oFont2)
nLin += 070  


oPrint:Say(nLin,nCol1	,cCabec1 + Alltrim(cNumero)	+ Space(40) + cCabec2 + DTOC(dData) ,oFont3)
nLin+= 60
oPrint:Say(nLin,nCol1	,cCabec3 + Alltrim(cClifor)+"/"+Alltrim(cLoja) + " - "+Alltrim(cNome)				,oFont3) 
nLin+= 60
oPrint:Say(nLin,020,Replicate("-",300)		,oFont2)
nLin+=50
oPrint:Say(nLin,nCol1	,cColuna1			,oFont3)
oPrint:Say(nLin,nCol2	,cColuna2			,oFont3) 
//oPrint:Say(nLin,nCol3	,cColuna3 			,oFont3)
oPrint:Say(nLin,nCol3	,cColuna4			,oFont3,,,,PAD_RIGHT)
oPrint:Say(nLin,nCol4	,cColuna5			,oFont3,,,,PAD_RIGHT)
nLin += 60
oPrint:Say(nLin,020,Replicate("_",300)	,oFont2)
nLin += 60

nPag++        

Return

/*///////////////////////////////////////////////////////////////////////////////////////////////
//Busca Quantidade do Pedido de Vebda						                                   //
///////////////////////////////////////////////////////////////////////////////////////////////*/
Static Function fBuscaPed(cNumero, cProd, cLote)

Local cQuery	:= ""
Local cAlias	:= getNextAlias()
Local nQtd		:= 0


If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf
             
cQuery:= " SELECT C6_QTDVEN "+CRLF
cQuery+= " FROM " + CRLF
cQuery+=   RetSqlName("SC6")+"  " + CRLF
cQuery+= " WHERE C6_NUM		= '"+ cNumero +"' "+CRLF
cQuery+= " AND C6_PRODUTO 	= '"+ cProd +"' "+CRLF
cQuery+= " AND C6_LOTECTL 	= '"+ cLote +"' "+CRLF
cQuery+= " AND D_E_L_E_T_ = '' "+CRLF

TcQuery cQuery new alias (cAlias)

(cAlias)->(dbGoTop())

if !(cAlias)->(Eof())
	nQtd:= (cAlias)->C6_QTDVEN
endif

Return(nQtd)
