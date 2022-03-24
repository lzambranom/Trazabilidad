#Include 'Protheus.ch'
#Include "RwMake.ch"
#Include 'TopConn.ch'
#INCLUDE "font.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"

#define	IMPRESSAO	"I"
#define	REIMPRESSAO	"R"


/*/{Protheus.doc} ETQRAST
Rotina de Menu. 
Executa rotina para Impressão da Etiqueta Anvisa de Rastreabilidade
@type function
@author Gerson
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function ETQRAST()

Local aParambox	:= {}
Local cPerg		:= "ETQRAS"
Local aOptions	:= ""
Local cLabel1	:= ""
Local cLabel2	:= ""

Private cIdioma := __LANGUAGE

if cIdioma == "SPANISH"
	cLabel1	:= "Opción"
	cLabel2	:= "Etiqueta de trazabilidad"
	aOptions:= {"1=Nota fiscal","2=Orden de venta","3=Orden de producción"}
elseif cIdioma == "ENGLISH"
	cLabel1	:= "Option"
	cLabel2	:= "Traceability Label"
	aOptions:= {"1=Invoice","2=Sales order","3=Production order"}
else
	cLabel1:= "Opção"
	cLabel2:= "Etiqueta de Rastreabilidade"
	aOptions:= {"1=Nota Fiscal","2=Pedido de Venda","3=Ordem de Produção"}
endif

aAdd(aParamBox,{2, cLabel1	,"1",aOptions,90,.F.,.T.}) //MV_PAR01

If ParamBox(aParamBox,cLabel2,,,,,,,,cPerg,.T.,.T.)
	if mv_par01 = "1"
		ETQNF() 
	elseif mv_par01 = "2"
		ETQPV()
	else
		ETQOP()
	endif		 	 
endif

Return


/*/{Protheus.doc} ETQNF
Rotina de Menu. 
Executa rotina para Impressão da Etiqueta Anvisa de Rastreabilidade
por NOTA FISCAL DE ETRADA 
@type function
@author Gerson
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ETQNF()

Local aParambox	:= {}
Local cPerg		:= "ETQNF"

Local cLabel3	:= ""
Local cLabel4	:= ""
Local cLabel5	:= ""
Local cLabel6	:= ""
Local cLabel7	:= ""

if cIdioma == "SPANISH"
	cLabel3	:= "Nota Fiscal"
	cLabel4	:= "Serie"
	cLabel5	:= "Proveedor"
	cLabel6	:= "Tienda"	
	cLabel7	:= "Etiqueta de trazabilidad - Nota Fiscal"
elseif cIdioma == "ENGLISH"
	cLabel3	:= "Invoice"
	cLabel4	:= "Series"
	cLabel5	:= "Provider"
	cLabel6	:= "Store"	
	cLabel7	:= "Traceability Label - Invoice"
else
	cLabel3	:= "Nota Fiscal"
	cLabel4	:= "Série"
	cLabel5	:= "Fornecedor"
	cLabel6	:= "Loja"
	cLabel7	:= "Etiqueta de Rastreabilidade - Nota Fiscal"	
endif


aAdd(aParamBox,{1,cLabel3 			,Space(TamSx3("F2_DOC ")[1]),"","","","",70,.F.}) //MV_PAR02  //ZZHNF
aAdd(aParamBox,{1,cLabel4 			,Space(TamSx3("F2_SERIE ")[1]),"","","","",30,.F.}) //MV_PAR03
aadd(aParamBox,{1,cLabel5 		   	,Space(TamSx3("A2_COD ")[1]),"","","SA2","",50  ,.F.}) //MV_PAR04
aadd(aParamBox,{1,cLabel6 		 	,Space(TamSx3("A2_LOJA ")[1]),"","","","",30  ,.F.}) //MV_PAR04


If ParamBox(aParamBox,cLabel7 ,,,,,,,,cPerg,.T.,.T.)
	Processa({||IMPETQ("NF")}) 
endif

Return


/*/{Protheus.doc} ETQPV
Rotina de Menu. 
Executa rotina para Impressão da Etiqueta Anvisa de Rastreabilidade
por Pedido de Venda 
@type function
@author Gerson
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ETQPV()

Local aParambox	:= {}
Local cPerg		:= "ETQPV"

Local cLabel8	:= ""
Local cLabel9	:= ""
Local cLabel10	:= ""
Local cLabel11	:= ""

if cIdioma == "SPANISH"
	cLabel8	:= "Orden de venta"
	cLabel9	:= "Cliente"
	cLabel10:= "Tienda"
	cLabel11:= "Etiqueta de trazabilidad - Orden de venta"
elseif cIdioma == "ENGLISH"
	cLabel8	:= "Sales Order"
	cLabel9	:= "Client"
	cLabel10:= "Store"	
	cLabel11:= "Traceability Label - Sales order"
else
	cLabel8	:= "Pedido de Venda"
	cLabel9	:= "Cliente"
	cLabel10:= "Loja"
	cLabel11:= "Etiqueta de Rastreabilidade - Pedido de Venda"	
endif

aAdd(aParamBox,{1,cLabel8 			,Space(TamSx3("C5_NUM")[1]),"","","","",70,.F.}) //MV_PAR02  //ZZHPV
aAdd(aParamBox,{1,cLabel9			,Space(TamSx3("C5_CLIENTE")[1]),"","","","",50,.F.}) //MV_PAR03
aadd(aParamBox,{1,cLabel10		   	,Space(TamSx3("C5_LOJACLI")[1]),"","","","",30  ,.F.}) //MV_PAR04

If ParamBox(aParamBox,cLabel11,,,,,,,,cPerg,.T.,.T.)
	Processa({||IMPETQ("PV")}) 
endif

Return

/*/{Protheus.doc} ETQOP
Rotina de Menu. 
Executa rotina para Impressão da Etiqueta Anvisa de Rastreabilidade
por Ordem de Produção 
@type function
@author Gerson
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ETQOP()

Local aParambox	:= {}
Local cPerg		:= "ETQOP"

Local cLabel12	:= ""
Local cLabel13	:= ""

if cIdioma == "SPANISH"
	cLabel12:= "Orden de producción"
	cLabel13:= "Etiqueta de trazabilidad - Orden de producción"
elseif cIdioma == "ENGLISH"
	cLabel12:= "Production order"
	cLabel13:= "Traceability Label - Production order"
else
	cLabel12:= "Ordem de Produção"
	cLabel13:= "Etiqueta de Rastreabilidade - Ordem de Produção"	
endif

aAdd(aParamBox,{1,cLabel12	,Space(TamSx3("D3_OP")[1]),"","","SC2","",70,.F.}) //MV_PAR02 

If ParamBox(aParamBox,cLabel13 ,,,,,,,,cPerg,.T.,.T.)
	Processa({||IMPETQ("OP")}) 
endif

Return


/*/{Protheus.doc} ETQOP
Rotina de Menu. 
Executa rotina para Impressão da Etiqueta Anvisa de Rastreabilidade
por Ordem de Produção 
@type function
@author Gerson
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function IMPETQ(cTipo)

Local cQuery		:= ""
Local cAlias		:= GetNextAlias()
Local nQtdEtq		:= 0
Local nNumEtq		:= 0
Local cResponsavel	:= SuperGetMV("ZZ_RESPON",,"") 
Local cCrea			:= SuperGetMV("ZZ_CREA",,"")

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQuery:= " SELECT COUNT(*) AS QTDREG "+CRLF 
cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF
if cTipo == "NF"
	cQuery+= "       ZZH_DOC	= '"+mv_par01+"'			AND "+CRLF
	cQuery+= "       ZZH_SERIE	= '"+mv_par02+"'			AND "+CRLF
	cQuery+= "       ZZH_FORNEC = '"+mv_par03+"'			AND "+CRLF
	cQuery+= "       ZZH_LOJA	= '"+mv_par04+"'			AND "+CRLF
elseif cTipo == "PV"
	cQuery+= "       ZZH_PEDIDO	 = '"+mv_par01+"'			AND "+CRLF
	cQuery+= "       ZZH_CLIENT  = '"+mv_par02+"'			AND "+CRLF
	cQuery+= "       ZZH_LOJA	 = '"+mv_par03+"'			AND "+CRLF
elseif cTipo == "OP"	
	cQuery+= "       ZZH_OP		 = '"+mv_par01+"'			AND "+CRLF
endif	
cQuery+= "       D_E_L_E_T_ = ' '  		                    "+CRLF

TcQuery cQuery New Alias &cAlias

if (cAlias)->QTDREG > 0

	nQtdEtq:= (cAlias)->QTDREG

	If Select(cAlias) > 0
		(cAlias)->(DbCloseArea())
	EndIf
	
	cQuery:= " SELECT ZZH_COD, ZZH_LOTE, ZZH_NUMETQ, ZZH_ENTRA "+CRLF 
	cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
	cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF
	if cTipo == "NF"
		cQuery+= "       ZZH_DOC	= '"+mv_par01+"'			AND "+CRLF
		cQuery+= "       ZZH_SERIE	= '"+mv_par02+"'			AND "+CRLF
		cQuery+= "       ZZH_FORNEC = '"+mv_par03+"'			AND "+CRLF
		cQuery+= "       ZZH_LOJA	= '"+mv_par04+"'			AND "+CRLF
	elseif cTipo == "PV"
		cQuery+= "       ZZH_PEDIDO	= '"+mv_par01+"'			AND "+CRLF
		cQuery+= "       ZZH_CLIENT = '"+mv_par02+"'			AND "+CRLF
		cQuery+= "       ZZH_LOJA	= '"+mv_par03+"'			AND "+CRLF
	elseif cTipo == "OP"	
		cQuery+= "       ZZH_OP		= '"+mv_par01+"'			AND "+CRLF
	endif	
	cQuery+= "       D_E_L_E_T_ = ' '  		                    "+CRLF
	
	TcQuery cQuery New Alias &cAlias

	(cAlias)->(dbGotop())
	
	While !(cAlias)->(Eof())
		
		//nNumEtq:= VAL((cAlias)->ZZH_NUMETQ)

		U_ETQANVRA(Alltrim((cAlias)->ZZH_COD) , Alltrim((cAlias)->ZZH_ENTRA), Alltrim((cAlias)->ZZH_LOTE), cCrea, cResponsavel, nNumEtq, nQtdEtq, cIdioma, CTOD(""),"","3" )
		// U_ETQANVRA(Alltrim((cAlias)->ZZH_COD) , dDataBase, Alltrim((cAlias)->ZZH_LOTE), cCrea, cResponsavel, nNumEtq, nQtdEtq, cIdioma, CTOD(""),"","3" )
	
		(cAlias)->(dbSkip())
	enddo
	
endif

Return
