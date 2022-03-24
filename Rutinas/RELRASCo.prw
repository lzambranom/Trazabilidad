#Include 'Protheus.ch'
#Include "RwMake.ch"
#Include 'TopConn.ch'
#INCLUDE "font.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"


/*/{Protheus.doc} RELRASTR
Rotina de Menu. 
Executa rotina para Impressão dos Relatórios de Rastreabilidade
@type function
@author 
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/	
User Function RELRASCo()

Local aParambox		:= {}
Local cPerg			:= "RELRAS"

Private cIdioma 	:= __LANGUAGE
Private aOptions	:= if(cIdioma == "SPANISH",{'1=Nota Fiscal de Entrada','2=Orden de venta','3=OP Entrada','4=OP SALIDA'},if(cIdioma == "ENGLISH",{'1=Incoming Invoice','2=Sales order','3=OP INPUT','4=OP OUTPUT'},{'1=Nota Fiscal de Entrada','2=Pedido de Venda','3=OP ENTRADA','4=OP SAIDA'}))
Private cOpcao		:= if(cIdioma == "SPANISH","Opción",if(cIdioma == "ENGLISH","Option","Opção")) 
Private cTitulo		:= if(cIdioma == "SPANISH","Informe de seguimiento",if(cIdioma == "ENGLISH","Traceability Report","Relatório de Rastreabilidade"))
Private cDesenv		:= if(cIdioma == "SPANISH","En desarrollo...",if(cIdioma == "ENGLISH","Under development...","Em Desenvolvimento..."))

aAdd(aParamBox,{2,cOpcao ,"1",aOptions,85,.F.,.T.}) //MV_PAR01

If ParamBox(aParamBox,cTitulo,,,,,,,,cPerg,.T.,.T.)
	if mv_par01 = "1"
		OPCNF() 
	elseif mv_par01 = "2"
		OPCPV()
	elseif mv_par01 = "3"
		OPCOPE()
	else
		msgAlert(cDesenv)
		//OPCOPS()
	endif		 	 
endif

Return


/*/{Protheus.doc} OPCNF
Rotina de Menu. 
Executa rotina para Impressão do Relatório de Rastreabilidade 
por NOTA FISCAL DE ETRADA 
@type function
@author 
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function OPCNF()

Local aParambox	:= {}
Local cPerg		:= "OPCNF"
Local cNome		:= ""
Local dData		:= CTOD("  /  /  ")

Local cCampo1	:= if(cIdioma == "SPANISH","Nota Fiscal",if(cIdioma == "ENGLISH","Invoice","Nota Fiscal"))
Local cCampo2	:= if(cIdioma == "SPANISH","Serie",if(cIdioma == "ENGLISH","Series","Série"))
Local cCampo3	:= if(cIdioma == "SPANISH","Proveedor",if(cIdioma == "ENGLISH","Provider","Fornecedor"))
Local cCampo4	:= if(cIdioma == "SPANISH","Tienda",if(cIdioma == "ENGLISH","Store","Loja"))
Local cTitulo	:= if(cIdioma == "SPANISH","Informe Rastreabilidad (Nota Fiscal)",if(cIdioma == "ENGLISH","Traceability Report (INVOICE)","Relatório Rastreabilidade (NOTA FISCA)"))
Local cAlerta	:= if(cIdioma == "SPANISH","NOTA FISCAL NO ENCONTRADA",if(cIdioma == "ENGLISH","INVOICE NOT FOUND","NOTA FISCAL NÃO ENCONTRADA"))
Local cAtencao	:= if(cIdioma == "SPANISH","ATENCIÓN",if(cIdioma == "ENGLISH","ATTENTION","ATENÇÃO"))


aAdd(aParamBox,{1,cCampo1			,Space(TamSx3("F1_DOC ")[1]),"","","SF102","",70,.F.}) //MV_PAR02
aAdd(aParamBox,{1,cCampo2			,Space(TamSx3("F1_SERIE ")[1]),"","","","",40,.F.}) //MV_PAR03
aadd(aParamBox,{1,cCampo3		   	,Space(TamSx3("A2_COD ")[1]),"","","SA2","",70  ,.F.}) //MV_PAR04
aadd(aParamBox,{1,cCampo4 		   	,Space(TamSx3("A2_LOJA")[1]),"","","","",40  ,.F.}) //MV_PAR04

If ParamBox(aParamBox,cTitulo,,,,,,,,cPerg,.T.,.T.)
	cNome:= Posicione("SA2",1,xFilial("SA2")+mv_par03+mv_par04,"A2_NOME")
	SD1->(dbSetOrder(1))
	if SD1->(dbSeek(xFilial("SD1")+mv_par01+mv_par02+mv_par03+mv_par04))
		dData:= SD1->D1_EMISSAO
		Processa({||U_RelNotaCo(mv_par01, mv_par02, mv_par03, mv_par04, cNome, dData)})
	else
		msgAlert(cAlerta,cAtencao)
	endif	 
endif

Return


/*/{Protheus.doc} OPCPV
Rotina de Menu. 
Executa rotina para Impressão do Relatório de Rastreabilidade
por Pedido de Venda 
@type function
@author 
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function OPCPV()

Local aParambox	:= {}
Local cPerg		:= "OPCPV"

Local cCampo1	:= if(cIdioma == "SPANISH","Orden de venta",if(cIdioma == "ENGLISH","Sales order","Pedido de Venda"))
Local cCampo2	:= if(cIdioma == "SPANISH","Cliente",if(cIdioma == "ENGLISH","Client","Cliente"))
Local cCampo3	:= if(cIdioma == "SPANISH","Tienda",if(cIdioma == "ENGLISH","Store","Loja"))
Local cTitulo	:= if(cIdioma == "SPANISH","Informe Rastreabilidad (Orden de venta)",if(cIdioma == "ENGLISH","Traceability Report (Sales Order)","Relatório Rastreabilidade (Pedido de Venda)"))
Local cAlerta	:= if(cIdioma == "SPANISH","PEDIDO DE VENTA NO ENCONTRADO",if(cIdioma == "ENGLISH","SALES ORDER NOT FOUND","PEDIDO DE VENDA NÃo ENCONTRADO"))
Local cAtencao	:= if(cIdioma == "SPANISH","ATENCIÓN",if(cIdioma == "ENGLISH","ATTENTION","ATENÇÃO"))


aAdd(aParamBox,{1,cCampo1 			,Space(TamSx3("C5_NUM")[1]),"","","SZHPV","",70,.F.}) //MV_PAR02
aAdd(aParamBox,{1,cCampo2			,Space(TamSx3("C5_CLIENTE")[1]),"","","SA1","",70,.F.}) //MV_PAR03
aadd(aParamBox,{1,cCampo3		   	,Space(TamSx3("C5_LOJACLI")[1]),"","","","",40  ,.F.}) //MV_PAR04

If ParamBox(aParamBox,cTitulo,,,,,,,,cPerg,.T.,.T.)
	cNome:= Posicione("SA1",1,xFilial("SA1")+mv_par02+mv_par03,"A1_NOME")
	SC5->(dbSetOrder(1))
	if SC5->(dbSeek(xFilial("SC5")+mv_par01))
		dData:= SC5->C5_EMISSAO
		Processa({||U_RELPEDCo(mv_par01,mv_par02,mv_par03,cNome,dData)})
	else
		msgAlert(cAlerta,cAtencao)
	endif	 
endif

Return


/*/{Protheus.doc} OPCOPE
Rotina de Menu. 
Executa rotina para Impressão do Relatório de Rastreabilidade
por Ordem de Produção 
@type function
@author 
@since 22/03/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function OPCOPE()

Local aParambox	:= {}
Local cPerg		:= "OPCOPE"

Local cCampo1	:= if(cIdioma == "SPANISH","Orden de producción",if(cIdioma == "ENGLISH","Production order","Ordem de Produção"))
Local cTitulo	:= if(cIdioma == "SPANISH","Informe Rastreabilidad (Orden de producción)",if(cIdioma == "ENGLISH","Traceability Report (Production order)","Relatório Rastreabilidade (Ordem de Produção)"))
Local cAlerta	:= if(cIdioma == "SPANISH","ORDEN DE PRODUCCIÓN NO ENCONTRADO",if(cIdioma == "ENGLISH","Production order NOT FOUND","ORDEM DE PRODUÇÃO NÃO ENCONTRADO"))
Local cAtencao	:= if(cIdioma == "SPANISH","ATENCIÓN",if(cIdioma == "ENGLISH","ATTENTION","ATENÇÃO"))


aAdd(aParamBox,{1,cCampo1 ,Space(TamSx3("D3_OP")[1]),"","","SC2","",70,.F.}) //MV_PAR02 

If ParamBox(aParamBox,cTitulo,,,,,,,,cPerg,.T.,.T.)
	SC2->(dbSetOrder(1))
	if SC2->(dbSeek(xFilial("SC2")+mv_par01))
		dData:= SC2->C2_EMISSAO
		Processa({||U_RELOPECo(mv_par01,dData)})
	else
		msgAlert(cAlerta,cAtencao)
	endif	 
 
endif

Return

