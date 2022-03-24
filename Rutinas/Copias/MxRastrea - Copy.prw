#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} RastreiaPrd
Tela de Processamento. Rastreabilidade de Produtos 
@type function
@author Gerson Schiavo
@since 04/02/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function MxRastrea() 

Local aArea:= GetArea()
Local lContinua:= .t.

Private aItemPv	:= {}
Private cItem	:= ""

While lContinua

	MontaTela(@lContinua)

Enddo

RestArea(aArea)

Return


Static Function MontaTela(lContinua)

Local oWBrowse1
Local aWBrowse1		:= {}
Local oFont1
Local oDlg 
Local oGroup
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10
Local aArea			:= GetArea()
Local cTitulo		:= ""      
Local nOpcao		:= 0
Local bNo			:= { || oDlg:End() }
Local bOk			:= { || oDlg:End(nOpcao:= 1) } 
Local aObjects 		:= {}
Local aPosObj  		:= {}
Local aSize			:= MsAdvSize()
Local aInfo    		:= {aSize[1],aSize[2],aSize[3],aSize[4],0,0}
Local oRadio
Local cNumero		:= Space(13)//space(Len(SF2->F2_DOC))
Local cSerie		:= space(Len(SF2->F2_SERIE))
Local cCliFor		:= space(Len(SA1->A1_COD))
Local cLoja			:= space(Len(SA1->A1_LOJA))
Local cNome			:= space(Len(SA1->A1_NOME))
Local cEtiqueta		:= Space(60)
Local cProduto		:= space(Len(SB1->B1_COD))
Local cLote			:= space(Len(ZZH->ZZH_LOTE))
Local cInvima		:= space(Len(ZZH->ZZH_INVIM1))  //M&H
Local cAutImp		:= space(Len(ZZH->ZZH_AUTIMP))
Local dData			:= CTOD("  /  / ")
Local dDtaVal		:= CTOD("  /  / ")
Local lOkEtq		:= .t.
Local lFiltra		:= .f.
Local dDtaFab		:= dDataBase
Local lRet			:= .t.
Local nNumEtq		:= 0
Local cResponsavel	:= SuperGetMV("ZZ_RESPON",,"") 
Local cCrea			:= SuperGetMV("ZZ_CREA",,"")
local aButtons		:= {} 
Local nReg 			:= 0
Local _cSRemito     := SuperGetMV('ZZ_SREMITO',, 'R') // Parametro utilizado para definição das séries que representam Remito.

Private lChk			:= .f.
Private lCpoData	:= Getmv("ZZ_VALID")
Private lCpoAutImp	:= Getmv("ZZ_AUTIMP ")

Private lPrdNotExist:= .f.
Private lImpEtq		:= GetMv("ZZ_IMPETIQ")
Private cIdioma 	:= __LANGUAGE

Private aTpReimp	:= {}
Private aTipoOps	:= {} 
Private oOk		 	:= LoadBitmap(GetResources(),"LBOK")
Private oNo		 	:= LoadBitmap(GetResources(),"LBNO")
Private cOBLocal	:= SuperGetMV("ZZ_OBLOCAL",,"")


cTitulo:= if(cIdioma == "SPANISH","Trazabilidad de los productos",if(cIdioma == "ENGLISH","Product Traceability","Rastreabilidade de Produtos"))

If cIdioma == "SPANISH"
	aTpReimp:= {'1-Impresión en la lectura','2-Impresión al finalizar','3-No Imprimir','4-Imprimir entradas al finalizar'}
	
	aTipoOps:= {'1-Nota Fiscal Entrada',	;
				'2-Orden de venta',			;
				'3-O.P. Entrada',			;
				'4-O.P. Salida'	,			;
				'5-Mov.Interno Entrada',	;
				'6-Mov.Interno Salida',		;
				'7-Devolución de Ventas',	;
				'8-Facturas de Ventas',		;
				'9-Dev. Pedido Ventas',		;
				'A-Transferencia',			;
				'B-Dev. Transferencia'		;
				}
				
ElseIf cIdioma == "ENGLISH"
	aTpReimp:= {'1-Print in Reading','2-Print to Finish','3-Do not Print','4-Print Entries when finalizing'}
	aTipoOps:= {'1-Incoming Invoice','2-Sales order','3-PO Input','4-PO Output','5-Inventory Input','6-Inventory Output','7-Sales Return','8-Outgoing Invoice','9-Dev. Sales Order','A-Transferencia','B-Dev. Transferencia'}
Else
	aTpReimp:= {'1-Imprimir na leitura','2-Imprimir ao finalizar','3-Não Imprimir','4-Imprimir Entradas ao Finalizar'}
	aTipoOps:= {'1-Nota Fiscal de Entrada','2-Pedido de Venda','3-OP Entrada','4-OP Saida','5-Mov.Interno Entrada','6-Mov.Interno Saida','7-Devolução de Venda','8-Nota Fiscal de Saída','9-Dev.Pedido vendas','A-Transferencia','B-Dev. Transferencia'}
Endif	
	
aadd( aObjects, { 100, 015, .T., .T. } )
aadd( aObjects, { 100, 085, .T., .T. } )
aPosObj  := MsObjSize( aInfo, aObjects, .T. )

//Faz o calculo automatico de dimensoes de objetos
oSize := FwDefSize():New(.T.)

oSize:lLateral	:= .F.
oSize:lProp		:= .T. // Proporcional

oSize:AddObject( "1STROW" ,  100, 37, .T., .T. ) // Totalmente dimensionavel
oSize:AddObject( "2NDROW" ,  100, 80, .T., .T. ) // Totalmente dimensionavel
oSize:AddObject( "3RDROW" ,  100, 10, .T., .T. ) // Totalmente dimensionavel
	
oSize:aMargins	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 

oSize:Process() // Dispara os calculos		

a2ndRow := {	oSize:GetDimension("2NDROW","LININI"),;
				oSize:GetDimension("2NDROW","COLINI"),;
				oSize:GetDimension("2NDROW","LINEND"),;
				oSize:GetDimension("2NDROW","COLEND")}

DEFINE MSDIALOG oDlg TITLE cTitulo From oSize:aWindSize[1],oSize:aWindSize[2] to oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL
oDlg:lMaximized := .T.

Define Font oFont1  Name "Arial Black" Size 0,-14 Bold    
Define Font oFont2  Name "Tahoma" Size 0,-12 Bold         
Define Font oFont3  Name "Arial Black" Size 0,-16 Bold    
 
*****************************************************************************************************
// Verifica o Idioma para exibicao
*****************************************************************************************************
if cIdioma == "SPANISH"
	cLabel1	:= "Tipo de Documento"
	cLabel2 := "Datos del documento"	
	cLabel3 := "Lea el Código de Barras"	
	cLabel4 := "Etiqueta Lida"
	cLabel5	:= "Impresión de la etiqueta"	
	cCampo1 := "NÚMERO"
	cCampo2	:= "SERIE"
	cCampo3 := "CLIENTE/PROVEEDOR"
	cCampo4 := "TIENDA"
	cCampo5 := "NOMBRE"
	cCampo6:= "FECHA"
	cCampo7 := "Producto"
	cCampo8	:= "Lote"
	cCampo9 := "Producto"
	cCampo10:= "Description"
	cCampo11:= "Lot"
	cCampo12:= "Fecha"
	cCampo13:= "Cliente/Proveedor"
	cCampo14:= "Tienda"
	cCampo15:= "Nombre"
	cCampo16:= "Caducidad"
	cCampo17:= "Aut.Importación:"
	cCampo18:= "Fecha de la Pérdida"
	cCampo19:= "Invima"
	cButton1:= "Elimina"
	cButton2:= "Filtro"
	cButton3:= "Impresión"
	cButton4:= "Replicar"
	cButton5:= "Orden de venta"
	cMensImp:= "¿Desea imprimir el informe ?"
	_cMsgEtq:= "Este registro tiene fecha de pérdida, no se permite imprimir la etiqueta."
	_cMsgInv:= "Código INVIMA inválido o caducado."
	cImprime:=  "Impresión..."
	
elseif cIdioma == "ENGLISH"
	cLabel1	:= "Document Type"
	cLabel2 := "Document Data"
	cLabel3 := "Read the Bar Code"
	cLabel4 := "Read Tag"
	cLabel5	:= "Label Printing"
	cCampo1 := "NUMBER"
	cCampo2	:= "SERIES"
	cCampo3 := "CLIENT/PROVIDER"
	cCampo4 := "SHOP"
	cCampo5 := "NAME"
	cCampo6 := "DATE"
	cCampo7 := "P R O D U C T"
	cCampo8 := "L O T"
	cCampo9 := "Product"
	cCampo10:= "Description"
	cCampo11:= "Lot"
	cCampo12:= "Date"
	cCampo13:= "Client/Provider"
	cCampo14:= "Shop"
	cCampo15:= "Name"
	cCampo16:= "Expiry"
	cCampo17:= "Aut.Import:"
	cCampo18:= "Date Loss"
	cCampo19:= "Invima"
	cButton1:= "Deleta"
	cButton2:= "Filter"
	cButton3:= "Printing"
	cButton4:= "Replicate"
	cButton5:= "Sales order"
	cMensImp:= "Do you want to print Report ?"
	_cMsgEtq:= "This record has a date of loss, it is not allowed to print the label."
	_cMsgInv:= "INVIMA invalid or expired code."
	cImprime:= "Printing..."	
	
else
	cLabel1	:= "Tipo de Documento"
	cLabel2 := "Dados do Documento"
	cLabel3 := "Leia o Código de Barras"
	cLabel4 := "Etiqueta Lida"
	cLabel5	:= "Impressão da Etiqueta"
	cCampo1	:= "NÚMERO"
	cCampo2	:= "SÉRIE"
	cCampo3 := "CLIENTE/FORNECEDOR"
	cCampo4 := "LOJA"
	cCampo5 := "NOME"
	cCampo6 := "DATA"
	cCampo7 := "P R O D U T O"
	cCampo8 := "L O T E"
	cCampo9 := "Produto"
	cCampo10:= "Descrição"
	cCampo11:= "Lote"
	cCampo12:= "Data"
	cCampo13:= "Cliente/Fornecedor"
	cCampo14:= "Loja"
	cCampo15:= "Nome"
	cCampo16:= "Validade"
	cCampo17:= "Aut.Importação:"
	cCampo18:= "Data Perda"
	cCampo19:= "Invima"  //M&H
	cButton1:= "Deleta"
	cButton2:= "Filtrar"
	cButton3:= "Imprime"
	cButton4:= "Replicar"
	cButton5:= "Pedido de Venda"
	cMensImp:= "Deseja imprimir Relatório ?"
	_cMsgEtq:= "Este registro tem data de perda, não é permitido impressão da etiqueta."
	_cMsgInv:= "Código INVIMA inválido ou vencido."
	cImprime:=  "Imprimindo..."
endif 
                                        
@ aPosObj[1,1]+2, aPosObj[1,2]+3 GROUP oGroup TO aPosObj[1,3]-17,aPosObj[1,1]+90 LABEL cLabel1 OF oDlg PIXEL Color CLR_BLUE
cCombo1:= aTipoOps[1]
oCombo1 := TComboBox():New(aPosObj[1,1]+8,aPosObj[1,1],{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;  //12
aTipoOps,80,13,oDlg,,,,,,.T.,,,,,,,,,'cCombo1') //20

@ aPosObj[1,3]-15, aPosObj[1,2]+3 GROUP oGroup TO aPosObj[1,3]+8,aPosObj[1,1]+90 LABEL cLabel5 OF oDlg PIXEL Color CLR_BLUE
cCombo2:= aTpReimp[1]
oCombo2 := TComboBox():New(aPosObj[1,1]+33,aPosObj[1,1],{|u|if(PCount()>0,cCombo2:=u,cCombo2)},; //38
aTpReimp,80,13,oDlg,,,,,,.T.,,,,,,,,,'cCombo2') //20


@ aPosObj[1,1]+2, aPosObj[1,1]+95 GROUP oGroup TO aPosObj[1,3]+8,aPosObj[1,4]-2 LABEL cLabel2 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+13, aPosObj[1,1]+98 SAY 	 oSay1 PROMPT cCampo1   				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+98 MsGet oGet1  Var cNumero					 	SIZE 060, 010 Valid !Empty(cNumero) .and. (fVldNum(oDlg,cNumero,@cClifor, @cLoja, @cNome, @dData, oWBrowse1, oDlg, @aWBrowse1, @lFiltra )) PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When .T.
@ aPosObj[1,1]+13, aPosObj[1,1]+160 SAY 	oSay2 PROMPT cCampo2  	 			SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+160 MsGet oGet2  Var cSerie					 	SIZE 030, 010 Valid(fVldDoc(oDlg,cNumero,cSerie,_cSRemito)) PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When Substr(cCombo1,1,1) $ "1|7|8"  
@ aPosObj[1,1]+13, aPosObj[1,1]+195 SAY 	 oSay3 PROMPT cCampo3			 	SIZE 070, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+195 MsGet oGet3  Var cCliFor				 	SIZE 070, 010 PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When Empty(cClifor) .and. ( Substr(cCombo1,1,1) $ "1|2|7|8|9" )   
@ aPosObj[1,1]+13, aPosObj[1,1]+270 SAY 	 oSay4 PROMPT cCampo4 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+270 MsGet oGet4  Var cLoja					 	SIZE 030, 010 Valid fDados(cNumero, cSerie, @cClifor, @cLoja, @dData,@cNome,oDlg,@aWBrowse1, oWBrowse1, Substr(cCombo1,1,1), @lOkEtq, @lFiltra, _cSRemito) PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When Empty(cLoja) .and. ( Substr(cCombo1,1,1) $ "1|2|7|8|9" )
@ aPosObj[1,1]+13, aPosObj[1,1]+305 SAY 	 oSay5 PROMPT cCampo5 				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+305 MsGet oGet5  Var cNome					 	SIZE 180, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .f.  
@ aPosObj[1,1]+13, aPosObj[1,1]+490 SAY 	 oSay6 PROMPT cCampo6 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+490 MsGet oGet6  Var dData					 	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .f.

//if lImpEtq .and. lCpoAutImp
if  lCpoData .and. lCpoAutImp
	@ aPosObj[1,1]+09, aPosObj[1,1]+560 SAY oSay6 PROMPT cCampo16 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
	@ aPosObj[1,1]+19 ,aPosObj[1,1]+560 MsGet oGet6  Var dDtaVal				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .t.  //!lFiltra
	@ aPosObj[1,1]+39, aPosObj[1,1]+490 SAY oSay7 PROMPT cCampo17 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
	@ aPosObj[1,1]+35 ,aPosObj[1,1]+560 MsGet oGet7  Var cAutImp				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .t.  //!lFiltra
elseif lCpoData .and. !lCpoAutImp
	@ aPosObj[1,1]+13, aPosObj[1,1]+560 SAY oSay6 PROMPT cCampo16 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
	@ aPosObj[1,1]+23 ,aPosObj[1,1]+560 MsGet oGet6  Var dDtaVal				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .t. //!lFiltra
elseif !lCpoData .and. lCpoAutImp
	@ aPosObj[1,1]+13, aPosObj[1,1]+560 SAY oSay7 PROMPT cCampo17 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
	@ aPosObj[1,1]+23 ,aPosObj[1,1]+560 MsGet oGet7  Var cAutImp				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .t. //!lFiltra
endif

@ aPosObj[1,1] + 60 , aPosObj[1,2]+3 GROUP oGroup TO aPosObj[1,3]+60, aPosObj[1,1]+230 LABEL cLabel3 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+78 ,aPosObj[1,2]+10 MsGet oGetcEtiqueta  Var cEtiqueta			SIZE 200, 010 Valid (fVldEtq(@lOkEtq,@cEtiqueta,@cProduto,@cLote,@aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp, _cMsgEtq, _cMsgInv) )PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When lOkEtq //!Empty(cEtiqueta) .and.

// PROTHEUS 12 - COLOMBIA
@ aPosObj[1,1]+60 , aPosObj[1,2]+270 GROUP oGroup TO aPosObj[1,3]+60, aPosObj[1,4]-2 LABEL cLabel4 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+65 , aPosObj[1,2]+280 SAY oSay8 PROMPT cCampo7			   		SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE 
@ aPosObj[1,1]+75 ,aPosObj[1,2]+280 MsGet oGet8  Var cProduto					SIZE 100, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cProduto) //.and. !lFiltra  
@ aPosObj[1,1]+65, aPosObj[1,2]+390 SAY oSay8 PROMPT cCampo8	 			 	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
//@ aPosObj[1,1]+75, aPosObj[1,2]+390 MsGet oGet9  Var cLote						SIZE 100, 010 Valid(fVldLote(@lOkEtq,@cEtiqueta,@cProduto,@cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp, _cMsgEtq, _cMsgInv)) PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cLote) //.and. !lFiltra

// M&H
@ aPosObj[1,1]+75, aPosObj[1,2]+390 MsGet oGet9  Var cLote						SIZE 100, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cLote) //.and. !lFiltr
@ aPosObj[1,1]+65, aPosObj[1,2]+500 SAY oSay8 PROMPT cCampo19	 			 	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+75, aPosObj[1,2]+500 MsGet oGet10  Var cInvima					SIZE 100, 010 Valid(fVldLote(@lOkEtq,@cEtiqueta,@cProduto,@cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp, _cMsgEtq, _cMsgInv)) PIXEL Of oDlg Font oFont2 F3 "SZ3" Color CLR_BLUE When Empty(cInvima)

//PROTHEUS 11 - MEXICO
//@ aPosObj[1,1] + 60 , aPosObj[1,2]+230 GROUP oGroup TO aPosObj[1,3]+60, aPosObj[1,4]-2 LABEL cLabel4 OF oDlg PIXEL Color CLR_BLUE
//@ aPosObj[1,1]+73, aPosObj[1,2]+240 SAY oSay8 PROMPT cCampo7			   		SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE 
//@ aPosObj[1,1]+83 ,aPosObj[1,2]+240 MsGet oGet8  Var cProduto					SIZE 150, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cProduto) //.and. !lFiltra  
//@ aPosObj[1,1]+73, aPosObj[1,2]+400 SAY oSay8 PROMPT cCampo8	 			 	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
//@ aPosObj[1,1]+83, aPosObj[1,2]+400 MsGet oGet9  Var cLote					SIZE 150, 010 Valid(fVldLote(@lOkEtq,@cEtiqueta,@cProduto,@cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp)) PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cLote) //.and. !lFiltra


oWBrowse1 := TCBrowse():New(a2ndRow[1]+30,a2ndRow[2]+10,a2ndRow[4]-65, a2ndRow[3]-135,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,.T.)//oPanel2
oWBrowse1:AddColumn(TCColumn():New(" "					,{||If(Len(aWBrowse1)>0,If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),oNo)},	,,,"CENTER"	,,.T.,.F.,,,,.F.,))	
oWBrowse1:AddColumn(TCColumn():New(cCampo9				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 2]," ")},PesqPict("SB1","B1_COD")			,,,"LEFT"	,70,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo10				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 3]," ")},PesqPict("SB1","B1_DESC")			,,,"LEFT"	,150,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo11				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 4]," ")},PesqPict("ZZH","ZZH_LOTE")		,,,"LEFT"	,60,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo12				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 5]," ")},PesqPict("SD1","D1_EMISSAO")		,,,"LEFT"	,50,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo13				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 6]," ")},PesqPict("SA1","A1_COD")			,,,"LEFT"	,60,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo14				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 7]," ")},PesqPict("SA1","A1_LOJA")			,,,"LEFT"	,30,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo15				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 8]," ")},PesqPict("SA1","A1_NOME")			,,,"LEFT"	,140,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo18				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 10]," ")},PesqPict("SF2","F2_EMISSAO")		,,,"LEFT"	,140,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo19				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 11]," ")},PesqPict("ZZH","ZZH_INVIM1")		,,,"LEFT"	,160,.F.,.F.,,,,.F.,)) //M&H


//oChkBox:= TCheckBox():New(aPosObj[2,3]-30, aPosObj[1,2]+13, "Marca/Desmarca Todos", bSetGet(lChk), oDlg, 080, 020,, {|| MarcaTodos(aWBrowse1,oWBrowse1,lChk,oDlg)})
oChkBox:= TCheckBox():New(aPosObj[2,3]-15, aPosObj[1,2]+13, "Marca/Desmarca Todos", bSetGet(lChk), oDlg, 080, 020,, {|| MarcaTodos(aWBrowse1,oWBrowse1,lChk,oDlg)})

@ a2ndRow[1]+30,a2ndRow[4]-40 BUTTON cButton1 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action (fDeletaItem(aWBrowse1, oWBrowse1, oDlg, lFiltra, Substr(cCombo1,1,1), cNumero, cSerie, cCliFor, cLoja))
@ a2ndRow[1]+70,a2ndRow[4]-40 BUTTON cButton3 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action fImprime(aWBrowse1,lFiltra,dDtaVal,cAutImp,_cMsgEtq,_cMsgInv)
@ a2ndRow[1]+110,a2ndRow[4]-40 BUTTON cButton4 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action fReplicar(@aWBrowse1, oWBrowse1, oDlg,cNumero, cSerie, cClifor, cLoja, cNome, dData, dDtaVal, cAutImp, Substr(cCombo1,1,1) )
//@ a2ndRow[1]+110,a2ndRow[4]-40 BUTTON cButton3 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action fImprime(aWBrowse1,lFiltra,dDtaVal)

*************************************************************************************************************************************************************************************************
aAdd(aButtons,{cButton5	,{|| ImportaPed(@aWBrowse1, oWBrowse1, oDlg,cNumero, cSerie, cClifor, cLoja, cNome, dData, dDtaVal, cAutImp, Substr(cCombo1,1,1)  )}	, cButton5, cButton5})  
                                                   
fWBrowse(oWBrowse1,aWBrowse1,oDlg) 


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bNo,Nil,aButtons) CENTERED  


if nOpcao = 1 //.and. !lFiltra

	if Len(aWBrowse1) > 0

		if Substr(cCombo1,1,1) $ "1/3/5/7" .and. Substr(cCombo2,1,1) = "2" // Ao Finalizar .or. Substr(cCombo1,1,1) = "3")
			For i:= 1 to Len(aWBrowse1)
				If Empty(aWBrowse1[i][10])
					If !Empty(aWBrowse1[i][11])
						U_ETQANVRA(Alltrim(aWBrowse1[i,2]) , dDataBase, Alltrim(aWBrowse1[i,4]), cCrea, cResponsavel, nNumEtq, Len(aWBrowse1),cIdioma, dDtaVal, cAutImp ,cOBLocal, AllTrim(aWBrowse1[i,11]))
					Else
						MsgAlert(_cMsgInv, 'Alerta')
					EndIf
				Else
					MsgAlert(_cMsgEtq, 'Alerta')
				EndIf
			Next i
		elseif Substr(cCombo1,1,1) $ "2/4" .and. Substr(cCombo2,1,1) = "4"  //Impressão das Etiquetas de Entrada quando Selecionado Pedido de Vebda ou OP SAIDA
			For i:= 1 to Len(aWBrowse1)
				nReg:= fBuscaEtq(Alltrim(aWBrowse1[i,2]),Alltrim(aWBrowse1[i,4]))
				if nReg > 0
					dbSelectArea("ZZH")
					dbGoto(nReg)
					If Empty(aWBrowse1[i][10])
						If !Empty(aWBrowse1[i][11])
							U_ETQANVRA(Alltrim(aWBrowse1[i,2]) , ZZH->ZZH_ENTRA , Alltrim(aWBrowse1[i,4]), cCrea, cResponsavel, nNumEtq, Len(aWBrowse1),cIdioma, dDtaVal, cAutImp ,cOBLocal, AllTrim(aWBrowse1[i,11]))
						Else
							MsgAlert(_cMsgInv, 'Alerta')
						EndIf
					Else
						MsgAlert(_cMsgEtq, 'Alerta')
					EndIf
				endif
			Next i		
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir después de Grabar                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MsgYesNo(cMensImp)
			if Substr(cCombo1,1,1) = "1" //Nota Fiscal de Entrada
				Processa({||U_RelNotaMx(cNumero, cSerie, cClifor, cLoja, cNome, dData)})
			elseif Substr(cCombo1,1,1) = "2" // Pedido de Venda
				Processa({||U_RELPEDMX(cNumero, cClifor, cLoja, cNome, dData)})
			elseif Substr(cCombo1,1,1) = "3"  // Ordem de Produçao Entrada
				Processa({||U_RELOPEMX(cNumero, dData)})
			elseif Substr(cCombo1,1,1) = "4"  // Ordem de Produçao Saida
				Processa({||U_RELOPSMX(cNumero, dData)})
			elseif Substr(cCombo1,1,1) = "5"  .or. Substr(cCombo1,1,1) = "6" // Inventário Entrada # Inventário Saída
				Processa({||U_RELMOVMX(cNumero, dData, Substr(cCombo1,1,1) )})
			endif	
		Endif
		
	else
		if cIdioma == "SPANISH"
			msgAlert("El documento no se puede escribir, ya que no se lee etiqueta","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Document can not be written because it has not been Read Label","A T T E N T I O N")
		else
			msgAlert("Documento não pode ser gravado, pois não foi Lido Etiqueta","A T E N Ç Ã O")
		endif
	endif
else
	lContinua:= .f.				
endif

RestArea(aArea)

Return


****************************************************************************************************************************************
//Monta o Browse dos Títulos e o Browse das Parcelas
****************************************************************************************************************************************
Static Function fWBrowse(oWBrowse1,aWBrowse1,oDlg)

	Local bValid		:= { || fvalEdit(oDlg,oWBrowse1,aWBrowse1 ) }

	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {" ",;
							aWBrowse1[oWBrowse1:nAT, 2],;
							aWBrowse1[oWBrowse1:nAT, 3],;
							aWBrowse1[oWBrowse1:nAT, 4],;
							aWBrowse1[oWBrowse1:nAt, 5],;
							aWBrowse1[oWBrowse1:nAt, 6],;
							aWBrowse1[oWBrowse1:nAt, 7],;
							aWBrowse1[oWBrowse1:nAt, 8]}}
							//aWBrowse1[oWBrowse1:nAt, 9]}}
							
	oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1], Eval(bValid),;
	oWBrowse1:DrawSelect()}							
	
	//oWBrowse1:bHeaderClick := {|| marcaTodos(aWBrowse1) , oWBrowse1:refresh()}
	
	oWBrowse1:nScrollType := 1
	//oWBrowse1:SetFocus()
	oWBrowse1:Refresh()

Return

                                                                                                                                      
//////////////////////////////////////////////////////////////////////////////////////////////////
//Valida Dodos do Cabeçalho
//////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDados(cNumero, cSerie, cClifor, cLoja, dData,cNome,oDlg, aWBrowse1, oWBrowse1, cCombo, lOkEtq, lFiltra, _cSRemito)
				
Local lRet	:= .T.
Local lAchou:= .F.

If Substr(cCombo1,1,1) = "1" //Nota Fiscal de Entrada
	cNumero := padr(Alltrim(cNumero),tamSx3("D1_DOC")[1])
	SA2->(dbSetOrder(1))
	if SA2->(dbSeek(xFilial("SA2")+cCliFor+cLoja))
		SF1->(dbSetOrder(1))
		if !SF1->(dbSeek(xFilial("SF1")+cNumero+cSerie+cClifor+cLoja))
		
			if cIdioma == "SPANISH"
				msgAlert("Nota Fiscal informada No existe !","A T E N C I Ó N")
			elseif cIdioma == "ENGLISH"
				msgAlert("Informed invoice Does not exist !","A T T E N T I O N")
			else
				msgAlert("Nota Fiscal informada Não existe !","A T E N Ç Ã O")	
			endif		
			
			cNumero	:= space(Len(SF1->F1_DOC)) 
			cCliFor	:= space(Len(SA1->A1_COD))
			cLoja	:= space(Len(SA1->A1_LOJA))
			lRet:= .f.
		else
			dData:= SF1->F1_EMISSAO		
			cNome:= Alltrim(SA2->A2_NOME)
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
		endif	
	else
		if cIdioma == "SPANISH"
			msgAlert("Proveedor informado No existe en el Registro !","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Supplier informed Not in the Register !","A T T E N T I O N")
		else
			msgAlert("Fornecedor informado Não existe no Cadastro !","A T E N Ç Ã O")
		endif		
		lRet:= .f.
	endif	
elseif Substr(cCombo1,1,1) = "2" // Pedido de Venda
	SA1->(dbSetOrder(1))
	if SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja))
		SC9->(dbSetOrder(2))
		if !SC9->(dbSeek(xFilial("SC9")+cClifor+cLoja+Alltrim(cNumero)))
			if cIdioma == "SPANISH"
				msgAlert("Solicitud de Venta No existe o no liberado !","A T E N C I Ó N")	
			elseif cIdioma == "ENGLISH"
				msgAlert("Sales Order Not Available or Not Released !","A T T E N T I O N")			
			else
				msgAlert("Pedido de Venda Não Existe ou Não Liberado !","A T E N Ç Ã O")	
			endif	
			cNumero	:= space(Len(SF2->F2_DOC)) 
			cCliFor	:= space(Len(SA1->A1_COD))
			cLoja	:= space(Len(SA1->A1_LOJA))
			lRet:= .f.	
		else
			dData:= SC9->C9_DATALIB	
			cNome:= Alltrim(SA1->A1_NOME)
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
		endif
	else
		if cIdioma == "SPANISH"
			msgAlert("El cliente no existe en el Registro !","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Customer not informed !","A T T E N T I O N")		
		else
			msgAlert("Cliente informado Não existe no Cadastro !","A T E N Ç Ã O")		
		endif	
		lRet:= .f.
	endif	
elseif Substr(cCombo1,1,1) = "3"  // Ordem de Produçao Entrada 
	cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])
	cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
	SD3->(dbSetOrder(1))
	if SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
		if SD3->D3_CF == "PR0"
			lAchou:= .t.
			dData:= SD3->D3_EMISSAO	
		endif	
	endif
elseif Substr(cCombo1,1,1) = "4"  //Ordem de Produção Saida
	SD4->(dbSetOrder(1))
	if SD4->(dbSeek(xFilial("SD4")+cProduto+Alltrim(cNumero)))
		lAchou:= .t.
		dData:= SD4->D4_DATA
		fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)	
	endif
	if !lAchou
		if cIdioma == "SPANISH"
			msgAlert("Orden de Producción informado No encontrado!","A T E N C I Ó N")		
		elseif cIdioma == "ENGLISH"
			msgAlert("Informed Production Order Not Found!","A T T E N T I O N")		
		else
			msgAlert("Ordem de Produção informado Não encontrada!","A T E N Ç Ã O")		
		endif	
		cNumero	:= space(Len(SF2->F2_DOC)) 
		cCliFor	:= space(Len(SA1->A1_COD))
		cLoja	:= space(Len(SA1->A1_LOJA))
		lRet:= .f.
	endif	
ElseIf SubStr(cCombo1,1,1) = "7" // Devolução de vendas.
	cNumero := PadR(AllTrim(cNumero), TamSX3("D1_DOC")[1])
	SA1->(DBSetOrder(1)) // Indice 1 - A1_FILIAL+A1_COD+A1_LOJA
	If SA1->(DBSeek(xFilial("SA1")+cCliFor+cLoja))
		SF1->(DBSetOrder(1)) // Indice 1 - F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		If !SF1->(DBSeek(xFilial("SF1")+cNumero+cSerie+cClifor+cLoja+'D'))
		
			If cIdioma == "SPANISH"
				MsgAlert("Devolución informada No existe !","A T E N C I Ó N")
			ElseIf cIdioma == "ENGLISH"
				MsgAlert("Informed return invoice Does not exist !","A T T E N T I O N")
			Else
				MsgAlert("Devolução informada Não existe !","A T E N Ç Ã O")	
			EndIf		
			
			cNumero	:= Space(Len(SF1->F1_DOC)) 
			cCliFor	:= Space(Len(SA1->A1_COD))
			cLoja	:= Space(Len(SA1->A1_LOJA))
			lRet:= .f.
		Else
			dData:= SF1->F1_EMISSAO		
			cNome:= AllTrim(SA1->A1_NOME)
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
		EndIf	
	Else
		If cIdioma == "SPANISH"
			MsgAlert("Cliente informado No existe en el Registro !","A T E N C I Ó N")
		ElseIf cIdioma == "ENGLISH"
			MsgAlert("Customer informed Not in the Register !","A T T E N T I O N")
		Else
			MsgAlert("Cliente informado Não existe no Cadastro !","A T E N Ç Ã O")
		EndIf		
		lRet:= .f.
	EndIf	
ElseIf SubStr(cCombo1,1,1) = "8" // Nota fiscal de saída.
	cNumero := PadR(AllTrim(cNumero), TamSX3("D2_DOC")[1])
	SA1->(DBSetOrder(1)) // Indice 1 - A1_FILIAL+A1_COD+A1_LOJA
	If SA1->(DBSeek(xFilial("SA1")+cCliFor+cLoja))
		SF2->(DBSetOrder(1)) // Indice 1 - F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		If !SF2->(DBSeek(xFilial("SF2")+cNumero+cSerie+cClifor+cLoja))
		
			If cIdioma == "SPANISH"
				MsgAlert("Factura de venta informada No existe !","A T E N C I Ó N")
			ElseIf cIdioma == "ENGLISH"
				MsgAlert("Informed outgoing invoice Does not exist !","A T T E N T I O N")
			Else
				MsgAlert("Devolución informada Não existe !","A T E N Ç Ã O")	
			EndIf		
			
			cNumero	:= Space(Len(SF2->F2_DOC)) 
			cCliFor	:= Space(Len(SA1->A1_COD))
			cLoja	:= Space(Len(SA1->A1_LOJA))
			lRet:= .f.
		Else
			If !(AllTrim(SF2->F2_SERIE) $ _cSRemito)
				If cIdioma == "SPANISH"
					MsgAlert("Factura no es un Remito !","A T E N C I Ó N")	
				ElseIf cIdioma == "ENGLISH"
					MsgAlert("Sales order is not a Remito !","A T T E N T I O N")		
				Else
					MsgAlert("Documento não é um Remito !","A T E N Ç Ã O")		
				EndIf	
				
				cNumero	:= Space(Len(SF2->F2_DOC)) 
				cCliFor	:= Space(Len(SA1->A1_COD))
				cLoja	:= Space(Len(SA1->A1_LOJA))
				lRet:= .f.
			Else
				dData:= SF2->F2_EMISSAO		
				cNome:= AllTrim(SA1->A1_NOME)
				fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
			EndIf
		EndIf	
	Else
		If cIdioma == "SPANISH"
			MsgAlert("Cliente informado No existe en el Registro !","A T E N C I Ó N")
		ElseIf cIdioma == "ENGLISH"
			MsgAlert("Customer informed Not in the Register !","A T T E N T I O N")
		Else
			MsgAlert("Cliente informado Não existe no Cadastro !","A T E N Ç Ã O")
		EndIf		
		lRet:= .f.
	EndIf	
	
/******************/
ElseIf Substr(cCombo1,1,1) == "9" // Dev.de Pedido
	SA1->(dbSetOrder(1))
	if SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja))
		SC5->(dbSetOrder(3))
		If !SC5->(dbSeek(xFilial("SC5")+cClifor+cLoja+Alltrim(cNumero)))
			If cIdioma == "SPANISH"
				msgAlert("Solicitud de Venta No existe !","A T E N C I Ó N")	
			Elseif cIdioma == "ENGLISH"
				msgAlert("Sales Order Not Available!","A T T E N T I O N")			
			Else
				msgAlert("Pedido de Venda Não Existe !","A T E N Ç Ã O")	
			Endif	
			cNumero	:= Space(Len(SF2->F2_DOC)) 
			cCliFor	:= Space(Len(SA1->A1_COD))
			cLoja	:= Space(Len(SA1->A1_LOJA))
			lRet	:= .F.
		Else
			dData:= SC5->C5_EMISSAO
			cNome:= Alltrim(SA1->A1_NOME)
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
		Endif
	Else
		If cIdioma == "SPANISH"
			msgAlert("El cliente no existe en el Registro !","A T E N C I Ó N")
		Elseif cIdioma == "ENGLISH"
			msgAlert("Customer not informed !","A T T E N T I O N")		
		Else
			msgAlert("Cliente informado Não existe no Cadastro !","A T E N Ç Ã O")		
		Endif	
		lRet:= .f.
		
	Endif
/******************/
ElseIf Substr(cCombo1,1,1) == "A" // Transferencia Interna Traspaso-SD3
	SD3->(dbSetOrder(2))
	If SD3->(dbSeek(xFilial("SD3")+cNumero))		
		dData:= SD3->D3_EMISSAO
		//cNome:= Alltrim(SA1->A1_NOME)
		fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
		
	Else
		cNumero	:= Space(Len(SD3->D3_DOC)) 			
		cCliFor	:= Space(Len(SA1->A1_COD))
		cLoja	:= Space(Len(SA1->A1_LOJA))
		lRet	:= .F.		
		
		If cIdioma == "SPANISH"
			msgAlert("Transferencia interna No existe!","A T E N C I Ó N")	
		Elseif cIdioma == "ENGLISH"
			msgAlert("Transfer Not Available!","A T T E N T I O N")	
		Else
			msgAlert("Transferencia Não Existe !","A T E N Ç Ã O")
		Endif		
		
	Endif
/******************/
ElseIf Substr(cCombo1,1,1) == "B" // Dev. Transferencia Interna Traspaso-SD3
	SD3->(dbSetOrder(2))
	If SD3->(dbSeek(xFilial("SD3")+cNumero))		
		dData:= SD3->D3_EMISSAO
		//cNome:= Alltrim(SA1->A1_NOME)
		fFiltrar(@aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra)
		
	Else
		cNumero	:= Space(Len(SD3->D3_DOC)) 			
		cCliFor	:= Space(Len(SA1->A1_COD))
		cLoja	:= Space(Len(SA1->A1_LOJA))
		lRet	:= .F.		
		
		If cIdioma == "SPANISH"
			msgAlert("Transferencia interna No existe!","A T E N C I Ó N")	
		Elseif cIdioma == "ENGLISH"
			msgAlert("Transfer Not Available!","A T T E N T I O N")	
		Else
			msgAlert("Transferencia Não Existe !","A T E N Ç Ã O")
		Endif		
		
	Endif
/******************/
Endif

oDlg:Refresh()

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldEtq(lOkEtq,cEtiqueta,cProduto,cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp, _cMsgEtq, _cMsgInv)

Local lRet		:= .t.
Local lAchouPed	:= .t.
Local nTamEtq	:= Len(Alltrim(cEtiqueta)) 
Local nPriPipe	:= At("|",cEtiqueta) //oFWChart:BSERIEACTION:={||ALERT("OI")}
Local nSegPipe	:= nTamEtq
Local nTamcId	:= Len(cEtiqueta)
Local cProduto	:= if(nPriPipe > 0, AllTrim(SubStr(cEtiqueta,1,nPriPipe-1)), Alltrim(cEtiqueta))
Local cLote		:= if(nPriPipe > 0, AllTrim(SubStr(cEtiqueta,nPriPipe+1,nSegPipe)), space(Len(ZZH->ZZH_LOTE)) )
Local nPipeLote	:= At("|",Substr(cLote,1,Len(cLote)))-1
Local cNrEtq	:= Right(Alltrim(cEtiqueta),3)
Local nTamPrd	:= Len(SB1->B1_COD)-Len(cProduto)
Local nTamLot	:= Len(ZZH->ZZH_LOTE)-Len(cLote)
Local nPos		:= 0
Local cMens		:= ""
Local lAchou	:= .f.
Local lVld		:= .f.
Local nNumEti	:= 0
Local lAchouProd:= .t.
Local nRegZZH	:= 0
Local cTipeB1	:= space(Len(SB1->B1_TIPE))
Local lCodOb	:= Getmv("ZZ_CODOB")  // .T. -> Usa B1_OBCOD e B1_OBSAP  para Validar Produto
Local cItemPv	:= ""
Local _dPerda   := CToD('//')
Local _cInvim1  := ''
Local _aInvOk   := {}
Local _cInvimOk := ''

if nPipeLote > 0
	cLote:= Substr(cLote,1,nPipeLote)
endif	 
	
if Empty(cProduto)
	cProduto	:= space(Len(SB1->B1_COD))
	cLote		:= space(Len(ZZH->ZZH_LOTE))
	cEtiqueta	:= Space(60)
	Return(.t.)
endif

//Validação da Data de Validade  
if Substr(cCombo1,1,1) = "1" .or. Substr(cCombo1,1,1) = "3" 
	cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + cProduto ,"B1_TIPE"))
	if Alltrim(SB1->B1_TIPE) == "F" .and. Empty(dDtaVal)
		cMens:= Upper("El producto necesita informar Fecha de Caducidad. ") + CRLF
		cMens += " " + CRLF
		msgAlert(cMens, "A T E N C I Ó N")
		cEtiqueta	:= Space(60)
		cProduto	:= space(Len(SB1->B1_COD))
		cLote		:= space(Len(ZZH->ZZH_LOTE))
		oDlg:Refresh()
		oGetcEtiqueta:Setfocus()
		oGetcEtiqueta:Refresh()
		lRet		:= .f.
		Return			
	endif
endif

if Empty(cNumero)
	if cIdioma == "SPANISH"
		cMens:= Upper("Para hacer la lectura de la etiqueta es necesario informar ") + CRLF
		cMens+= Upper("tipo y datos del documento (Información de encabezado.") + CRLF
		cMens += " " + CRLF
		msgAlert(cMens, "A T E N C I Ó N")
	elseif cIdioma == "ENGLISH"
		cMens:= Upper("To read the label, it is necessary to inform ") + CRLF
		cMens+= Upper("document Type and Data (Header Information.") + CRLF
		cMens += " " + CRLF
		msgAlert(cMens, "A T T E N T I O N")
	else
		cMens:= Upper("Para fazer a Leitura da Etiqueta é necessário informar ") + CRLF
		cMens+= Upper("o Tipo e os Dados do Documento (Informações do Cabeçalho.") + CRLF
		cMens += " " + CRLF
		msgAlert(cMens, "A T E N Ç Ã O")
	endif		
	cEtiqueta	:= Space(60)
	cProduto	:= space(Len(SB1->B1_COD))
	cLote		:= space(Len(ZZH->ZZH_LOTE))
	lRet		:= .f.			
else		
	cProduto:= cProduto+Space(nTamPrd)
	cLote	:= cLote+Space(nTamLot)
	if !Empty(cProduto)	
		SB1->(dbSetOrder(1))
		if !SB1->(dbSeek(xFilial("SB1")+cProduto))
			if lCodOb  //Usa B1_OBCOD e B1_OBSAP
				SB1->(dbOrderNickName("SB1COD"))
				if !SB1->(dbSeek(xFilial("SB1")+cProduto))
					SB1->(dbOrderNickName("SB1SAP"))
					if !SB1->(dbSeek(xFilial("SB1")+cProduto))
						lAchouProd:= .f.
					else
						cProduto := SB1->B1_COD
						_cInvim1 := SB1->B1_ZZINVIM
						_aInvOk  := CODINVIMA(cProduto, _cInvim1)

						If !_aInvOk[1]
							_cInvimOk := ''
						Else
							_cInvimOk := _aInvOk[2]
						EndIf
					endif
				else
					cProduto := SB1->B1_COD	
					_cInvim1 := SB1->B1_ZZINVIM
					_aInvOk  := CODINVIMA(cProduto, _cInvim1)

					If !_aInvOk[1]
						_cInvimOk := ''
					Else
						_cInvimOk := _aInvOk[2]
					EndIf
				endif
			else
				lAchouProd:= .f.
			endif		
		else
			cProduto := SB1->B1_COD
			_cInvim1 := SB1->B1_ZZINVIM
			_aInvOk  := CODINVIMA(cProduto, _cInvim1)

			If !_aInvOk[1]
				_cInvimOk := ''
			Else
				_cInvimOk := _aInvOk[2]
			EndIf
		endif
	endif
		
	If lAchouProd
	
		If Substr(cCombo1,1,1) = "1" //Nota Fiscal de Entrada
			cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])	
			cNumero := padr(Alltrim(cNumero),tamSx3("D1_DOC")[1])

			if !Empty(cLote)				
			
				Aadd(aWBrowse1,	{	.f.						,;
									cProduto				,;
									Alltrim(SB1->B1_DESC)	,;
									cLote					,;
									dDataBase				,;
									cCliFor					,;
									cLoja					,;
									cNome					,;
									0						,;
									_dPerda					,;
									_cInvimOk				})
			else
				lOkEtq:= .f.
				lRet:= .f.
			endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ fVldEtq / 2-Pedido de Venta   			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Elseif Substr(cCombo1,1,1) = "2" // Pedido de Venda
					
			nRegZZH := fBuscaEtq(cProduto,cLote)
			If nRegZZH == 0
				msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")	
				lRet:= .f.
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
				Return
			Endif
			
			/*
			//Verifica la Fecha de Validez del Invima del Producto
			*/
			If nRegZZH > 0
				dbSelectArea("ZZH")
				ZZH->(dbGoto(nRegZZH))
				lRet := ValDtInv(ZZH->ZZH_INVIM1)
			Endif
			
			if !Empty(cProduto)
				lAchouPed:= fQryPed(Alltrim(cNumero),cProduto, @aItemPv, @cItemPv)
			else
				lAchouPed:=.f.
			endif	
			
			if lAchouPed .AND. lRet
				if !Empty(cLote)
								
					//nRegZZH:= fBuscaEtq(cProduto,cLote)
					
					if nRegZZH > 0
					
						cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + cProduto ,"B1_TIPE"))
						if Alltrim(SB1->B1_TIPE) == "F" 
							ZZH->(dbGoto(nRegZZH))
							if !Empty(ZZH->ZZH_VALID) .and. dDataBase > ZZH->ZZH_VALID
								cMens:= "Fecha de validez vencida ! " + CRLF
								cMens+= "Desea grabar el producto ? " + CRLF
								If !MsgYesNo(cMens,"A T E N C I Ó N")
									lRet		:= .f.
									cEtiqueta	:= Space(60)
									cProduto	:= space(Len(SB1->B1_COD))
									cLote		:= space(Len(ZZH->ZZH_LOTE))
									oDlg:Refresh()
									oGetcEtiqueta:Setfocus()
									oGetcEtiqueta:Refresh()
								else
									lRet:= .t.
								endif
							endif
							_dPerda := ZZH->ZZH_PERDA
						endif									
				
						if lRet
							Aadd(aWBrowse1,	{	.f.						,;
												cProduto				,;
												Alltrim(SB1->B1_DESC)	,;
												cLote					,;
												dDataBase				,;
												cCliFor					,;
												cLoja					,;
												cNome					,;
												0						,;
												_dPerda					,;
												_cInvimOk				})
												
						endif						
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")	
						lRet:= .f.
						cProduto	:= space(Len(SB1->B1_COD))
						cLote		:= space(Len(ZZH->ZZH_LOTE))
						cEtiqueta	:= Space(60)
						oDlg:Refresh()
						oGetcEtiqueta:Setfocus()
						oGetcEtiqueta:Refresh()
					endif						
				else
					lOkEtq:= .f.
					lRet:= .f.
				endif
			else
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				lRet		:=.F.
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
			endif
		
		Elseif Substr(cCombo1,1,1) = "3" .or. Substr(cCombo1,1,1) = "4" // Ordem de Produção Entrada # SAIDA
			if Substr(cCombo1,1,1) = "3"
				cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])
				cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
				SD3->(dbSetOrder(1))
				if SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
					if SD3->D3_CF == "PR0"
						lAchou:= .t.
					endif		
				endif
			else // Ordem de Produção Saida
				cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])
				cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
				SD4->(dbSetOrder(1))
				if SD4->(dbSeek(xFilial("SD4")+cProduto+Alltrim(cNumero)))
					lAchou:= .t.
				endif
			endif	
			if lAchou
				if !Empty(cLote)
	
					if Substr(cCombo1,1,1) $ "3"
					
						Aadd(aWBrowse1,	{	.f.						,;
											cProduto				,;
											Alltrim(SB1->B1_DESC)	,;
											cLote					,;
											dDataBase				,;
											cCliFor					,;
											cLoja					,;
											cNome					,;
											0						,;
											_dPerda					,;
											_cInvimOk				})
					else
						nRegZZH:= fBuscaEtq(cProduto,cLote)
	
						if nRegZZH > 0
	
							cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + cProduto ,"B1_TIPE"))
							If Alltrim(SB1->B1_TIPE) == "F" 
								ZZH->(dbGoto(nRegZZH))
								if !Empty(ZZH->ZZH_VALID) .and. dDataBase > ZZH->ZZH_VALID
									cMens:= "Fecha de validez vencida ! " + CRLF
									cMens+= "Desea grabar el producto ? " + CRLF
									If !MsgYesNo(cMens,"A T E N C I Ó N")
										lRet		:= .f.
										cEtiqueta	:= Space(60)
										cProduto	:= space(Len(SB1->B1_COD))
										cLote		:= space(Len(ZZH->ZZH_LOTE))
										oDlg:Refresh()
										oGetcEtiqueta:Setfocus()
										oGetcEtiqueta:Refresh()
									endif
								endif
								_dPerda := ZZH->ZZH_PERDA
							Endif

							/*
							//Verifica la Fecha de Validez del Invima del Producto
							*/
							If nRegZZH > 0
								dbSelectArea("ZZH")
								ZZH->(dbGoto(nRegZZH))
								lRet := ValDtInv(ZZH->ZZH_INVIM1)
							Endif
	
							if lRet					
								Aadd(aWBrowse1,	{	.f.						,;
													cProduto				,;
													Alltrim(SB1->B1_DESC)	,;
													cLote					,;
													dDataBase				,;
													cCliFor					,;
													cLoja					,;
													cNome					,;
													0						,;
													_dPerda					,;
													_cInvimOk				})
							endif						
						else
							msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
							lRet:= .f.
							cProduto	:= space(Len(SB1->B1_COD))
							cLote		:= space(Len(ZZH->ZZH_LOTE))
							cEtiqueta	:= Space(60)
							oDlg:Refresh()
							oGetcEtiqueta:Setfocus()
							oGetcEtiqueta:Refresh()
						endif						
					endif							
				else
					lOkEtq:= .f.
					lRet:= .f.
				endif
			else
				if !(Empty(cProduto))
					if cIdioma == "SPANISH"
						msgAlert("Producto No se encuentra en la Orden de Producción informada !","A T E N C I Ó N")
					elseif cIdioma == "ENGLISH"
						msgAlert("Product Not in the Order of Production informed !","A T T E N T I O N")
					else
						msgAlert("Produto Não se encontra na Ordem de Produção informada !","A T E N Ç Ã O")
					endif
				endif		
				lRet:= .f.
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
			endif
		Elseif Substr(cCombo1,1,1) = "5" .or. Substr(cCombo1,1,1) = "6" // Movimento Interno # ENTRADA # SAIDA
			lAchou:= .f.
			if Substr(cCombo1,1,1) = "5"  //ENTRADA
				cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])	
				cNumero := padr(Alltrim(cNumero),tamSx3("D3_DOC")[1])
				SD3->(dbSetOrder(2))
				if SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
					While !SD3->(Eof()) .and. SD3->D3_DOC == cNumero .and. SD3->D3_COD == cProduto
						if SubStr(SD3->D3_CF,1,1) == "D"  .and. Empty(SD3->D3_ESTORNO)
							lAchou:= .t.
							exit
						endif
						SD3->(dbSkip())
					enddo				
				endif
			else // SAIDA
				cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])
				cNumero := padr(Alltrim(cNumero),tamSx3("D3_DOC")[1])
				SD3->(dbSetOrder(2))
				if SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
					While !SD3->(Eof()) .and. SD3->D3_DOC == cNumero .and. SD3->D3_COD == cProduto
						if SubStr(SD3->D3_CF,1,1) == "R"  .and. Empty(SD3->D3_ESTORNO)
							lAchou:= .t.
							exit							
						endif	
						SD3->(dbSkip())		
					enddo
				endif	
			endif	
			if lAchou
				if !Empty(cLote)
	
					if Substr(cCombo1,1,1) $ "5"
					
						Aadd(aWBrowse1,	{	.f.						,;
											cProduto				,;
											Alltrim(SB1->B1_DESC)	,;
											cLote					,;
											dDataBase				,;
											cCliFor					,;
											cLoja					,;
											cNome					,;
											0						,;
											_dPerda					,;
											_cInvimOk				})
					else
						nRegZZH:= fBuscaEtq(cProduto,cLote)
	
						if nRegZZH > 0
	
							cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + cProduto ,"B1_TIPE"))
							If Alltrim(SB1->B1_TIPE) == "F" 
								ZZH->(dbGoto(nRegZZH))
								if !Empty(ZZH->ZZH_VALID) .and. dDataBase > ZZH->ZZH_VALID
									cMens:= "Fecha de validez vencida ! " + CRLF
									cMens+= "Desea grabar el producto ? " + CRLF
									If !MsgYesNo(cMens,"A T E N C I Ó N")
										lRet		:= .f.
										cEtiqueta	:= Space(60)
										cProduto	:= space(Len(SB1->B1_COD))
										cLote		:= space(Len(ZZH->ZZH_LOTE))
										oDlg:Refresh()
										oGetcEtiqueta:Setfocus()
										oGetcEtiqueta:Refresh()
									endif
								endif
								_dPerda := ZZH->ZZH_PERDA
							Endif									
							
							/*
							//Verifica la Fecha de Validez del Invima del Producto
							*/
							If nRegZZH > 0
								dbSelectArea("ZZH")
								ZZH->(dbGoto(nRegZZH))
								lRet := ValDtInv(ZZH->ZZH_INVIM1)
							Endif
							
							If lRet					
								Aadd(aWBrowse1,	{	.f.						,;
													cProduto				,;
													Alltrim(SB1->B1_DESC)	,;
													cLote					,;
													dDataBase				,;
													cCliFor					,;
													cLoja					,;
													cNome					,;
													0						,;
													_dPerda					,;
													_cInvimOk				})
							Endif						
						else
							msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
							lRet:= .f.
							cProduto	:= space(Len(SB1->B1_COD))
							cLote		:= space(Len(ZZH->ZZH_LOTE))
							cEtiqueta	:= Space(60)
							oDlg:Refresh()
							oGetcEtiqueta:Setfocus()
							oGetcEtiqueta:Refresh()
						endif						
					endif							
				else
					lOkEtq:= .f.
					lRet:= .f.
				endif
			else
				if !(Empty(cProduto))
					if cIdioma == "SPANISH"
						msgAlert("Producto No se encuentra en la Movimientos Internos informado !","A T E N C I Ó N")
					elseif cIdioma == "ENGLISH"
						msgAlert("Product Not in the Inventory informed !","A T T E N T I O N")
					else
						msgAlert("Produto Não se encontra nos Movimentos Internos informado !","A T E N Ç Ã O")
					endif
				endif		
				lRet:= .f.
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
			endif
		ElseIf Substr(cCombo1,1,1) = "7" // Devolução de venda.
			cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])	
			cNumero := padr(Alltrim(cNumero),tamSx3("D1_DOC")[1])

			SD1->(DBSetOrder(1)) // Indice 1 - D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If SD1->(DBSeek(xFilial('SD1')+cNumero+cSerie+cCliFor+cLoja+cProduto))

				If !Empty(cLote)				
				
					Aadd(aWBrowse1,	{	.f.						,;
										cProduto				,;
										Alltrim(SB1->B1_DESC)	,;
										cLote					,;
										dDataBase				,;
										cCliFor					,;
										cLoja					,;
										cNome					,;
										0						,;
										_dPerda					,;
										_cInvimOk				})
				Else
					lOkEtq:= .f.
					lRet:= .f.
				EndIf
			
			Else
				lOkEtq:= .f.
				lRet:= .f.
			EndIf

		ElseIf Substr(cCombo1,1,1) == "8" // Nota fiscal de saída.
			
			nRegZZH := fBuscaEtq(cProduto,cLote)
			if nRegZZH == 0
				msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")	
				lRet:= .f.
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
				Return
			endif
			
			/*
			//Verifica la Fecha de Validez del Invima del Producto
			*/
			If nRegZZH > 0
				dbSelectArea("ZZH")
				ZZH->(dbGoto(nRegZZH))
				lRet := ValDtInv(ZZH->ZZH_INVIM1)
			Endif
			
			if !Empty(cProduto)
				SD2->(DBSetOrder(3)) // Indice 3 - D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				If SD2->(DBSeek(xFilial('SD2')+cNumero+cSerie+cCliFor+cLoja+cProduto))
					lAchouPed:= .T.
				Else
					lAchouPed:= .F.
				EndIf
			else
				lAchouPed:=.f.
			endif	
			
			if lAchouPed .AND. lRet
				if !Empty(cLote)
								
					//nRegZZH:= fBuscaEtq(cProduto,cLote)
					
					if nRegZZH > 0
					
						cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + cProduto ,"B1_TIPE"))
						if Alltrim(SB1->B1_TIPE) == "F" 
							ZZH->(dbGoto(nRegZZH))
							if !Empty(ZZH->ZZH_VALID) .and. dDataBase > ZZH->ZZH_VALID
								cMens:= "Fecha de validez vencida ! " + CRLF
								cMens+= "Desea grabar el producto ? " + CRLF
								If !MsgYesNo(cMens,"A T E N C I Ó N")
									lRet		:= .f.
									cEtiqueta	:= Space(60)
									cProduto	:= space(Len(SB1->B1_COD))
									cLote		:= space(Len(ZZH->ZZH_LOTE))
									oDlg:Refresh()
									oGetcEtiqueta:Setfocus()
									oGetcEtiqueta:Refresh()
								else
									lRet:= .t.
								endif
							endif
							_dPerda := ZZH->ZZH_PERDA
						endif									
				
						if lRet
							Aadd(aWBrowse1,	{	.f.						,;
												cProduto				,;
												Alltrim(SB1->B1_DESC)	,;
												cLote					,;
												dDataBase				,;
												cCliFor					,;
												cLoja					,;
												cNome					,;
												0						,;
												_dPerda					,;
												_cInvimOk				})
												
						endif						
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")	
						lRet:= .f.
						cProduto	:= space(Len(SB1->B1_COD))
						cLote		:= space(Len(ZZH->ZZH_LOTE))
						cEtiqueta	:= Space(60)
						oDlg:Refresh()
						oGetcEtiqueta:Setfocus()
						oGetcEtiqueta:Refresh()
					endif						
				else
					lOkEtq:= .f.
					lRet:= .f.
				endif
			else
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				lRet		:=.f.
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
			endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ fVldEtq / 9-Dev. Pedido de Venta   		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Elseif Substr(cCombo1,1,1) == "9" // Dev. Pedido de Venda
			
			cNumero := PadR(Alltrim(cNumero),TamSx3("C5_NUM")[1])			
			nRegZZH := fBuscaEtq(cProduto,cLote,cNumero)
			If nRegZZH == 0
				
				MsgAlert("No hay Saldo para Grabar Etiqueta (Dev.) !","A T E N C I Ó N")	
				lRet:= .F.
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
				Return
			Endif
			
			If !Empty(cProduto)
				lAchouPed:= fQryPed(Alltrim(cNumero),cProduto, @aItemPv, @cItemPv)
			Else
				lAchouPed:=.f.
			Endif	
			
			If lAchouPed
				if !Empty(cLote)
								
					//nRegZZH:= fBuscaEtq(cProduto,cLote)
					
					If nRegZZH > 0
					
						cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + cProduto ,"B1_TIPE"))
						If Alltrim(SB1->B1_TIPE) == "F" 
							ZZH->(dbGoto(nRegZZH))
							if !Empty(ZZH->ZZH_VALID) .and. dDataBase > ZZH->ZZH_VALID
								cMens:= "Fecha de validez vencida ! " + CRLF
								cMens+= "Desea grabar el producto ? " + CRLF
								If !MsgYesNo(cMens,"A T E N C I Ó N")
									lRet		:= .f.
									cEtiqueta	:= Space(60)
									cProduto	:= space(Len(SB1->B1_COD))
									cLote		:= space(Len(ZZH->ZZH_LOTE))
									oDlg:Refresh()
									oGetcEtiqueta:Setfocus()
									oGetcEtiqueta:Refresh()
								else
									lRet:= .t.
								endif
							endif
							_dPerda := ZZH->ZZH_PERDA
						Endif									
				
						If lRet
							Aadd(aWBrowse1,	{	.F.						,;
												cProduto				,;
												Alltrim(SB1->B1_DESC)	,;
												cLote					,;
												dDataBase				,;
												cCliFor					,;
												cLoja					,;
												cNome					,;
												0						,;
												_dPerda					,;
												_cInvimOk				})
												
						Endif
					Else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")	
						lRet:= .F.
						cProduto	:= space(Len(SB1->B1_COD))
						cLote		:= space(Len(ZZH->ZZH_LOTE))
						cEtiqueta	:= Space(60)
						oDlg:Refresh()
						oGetcEtiqueta:Setfocus()
						oGetcEtiqueta:Refresh()
					Endif						
				Else
					lOkEtq	:= .F.
					lRet	:= .F.
				Endif
			Else
				cProduto	:= Space(Len(SB1->B1_COD))
				cLote		:= Space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				lRet		:=.F.
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()
			endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ fVldEtq / A-Transferencia Interna		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Elseif Substr(cCombo1,1,1) == "A"
			lAchou:= .F.
			cNumero := PadR(cNumero,TamSx3("D3_DOC")[1])			
			cProduto:= Padr(Alltrim(cProduto),TamSx3("B1_COD")[1])
			
			SD3->(dbSetOrder(2))
			If SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
				While !SD3->(Eof()) .and. SD3->D3_DOC == cNumero .and. SD3->D3_COD == cProduto
					If SD3->D3_TM=='999' .And. SD3->D3_CF == "RE4"  .And. Empty(SD3->D3_ESTORNO)
						
						If SD3->D3_LOCAL $ GETNEWPAR("MV_XTRFSAL","20|25")
							lAchou := .T.
							Exit
						Endif
					Endif
					SD3->(dbSkip())
				Enddo				
			Endif			
			
			If lAchou
				If !Empty(cLote)
					
					nRegZZH := fBuscaEtq(cProduto,cLote)
					If nRegZZH == 0
						
						MsgAlert("No hay Saldo para Grabar Etiqueta (TRF.) !","A T E N C I Ó N")	
						lRet:= .F.
						cProduto	:= space(Len(SB1->B1_COD))
						cLote		:= space(Len(ZZH->ZZH_LOTE))
						cEtiqueta	:= Space(60)
						oDlg:Refresh()
						oGetcEtiqueta:Setfocus()
						oGetcEtiqueta:Refresh()
						Return
					Endif
					
					/*
					//Verifica la Fecha de Validez del Invima del Producto
					*/
					If nRegZZH > 0
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRegZZH))
						lRet := ValDtInv(ZZH->ZZH_INVIM1)
					Endif
					
					Aadd(aWBrowse1,	{	.F.						,;
										cProduto				,;
										Alltrim(SB1->B1_DESC)	,;
										cLote					,;
										dDataBase				,;
										cCliFor					,;
										cLoja					,;
										cNome					,;
										0						,;
										_dPerda					,;
										_cInvimOk				})
				Else
					lOkEtq	:= .F.
					lRet	:= .F.
				Endif
			Else
				MsgAlert("No es Transferencia de Despacho /Depósito incorrecto!","A T E N C I Ó N")
				cProduto	:= Space(Len(SB1->B1_COD))
				cLote		:= Space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				lRet		:=.F.
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()			
			Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ fVldEtq / B-Transferencia Interna		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Elseif Substr(cCombo1,1,1) == "B"
			lAchou:= .F.
			cNumero := PadR(cNumero,TamSx3("D3_DOC")[1])			
			cProduto:= Padr(Alltrim(cProduto),TamSx3("B1_COD")[1])
			
			SD3->(dbSetOrder(2))
			If SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
				While !SD3->(Eof()) .and. SD3->D3_DOC == cNumero .and. SD3->D3_COD == cProduto
					If SD3->D3_TM=='999' .And. SD3->D3_CF == "RE4"  .And. Empty(SD3->D3_ESTORNO)
						
						If SD3->D3_LOCAL # GETNEWPAR("MV_XTRFSAL","20|25")
							lAchou := .T.
							Exit
						Endif
					Endif
					SD3->(dbSkip())
				Enddo				
			Endif			
			
			If lAchou
				If !Empty(cLote)
					
					nRegZZH := fBuscaEtq(cProduto,cLote)
					If nRegZZH == 0
						
						MsgAlert("No hay Saldo para Grabar Etiqueta (TRF.DEV) !","A T E N C I Ó N")	
						lRet:= .F.
						cProduto	:= space(Len(SB1->B1_COD))
						cLote		:= space(Len(ZZH->ZZH_LOTE))
						cEtiqueta	:= Space(60)
						oDlg:Refresh()
						oGetcEtiqueta:Setfocus()
						oGetcEtiqueta:Refresh()
						Return
					Endif
				
					Aadd(aWBrowse1,	{	.F.						,;
										cProduto				,;
										Alltrim(SB1->B1_DESC)	,;
										cLote					,;
										dDataBase				,;
										cCliFor					,;
										cLoja					,;
										cNome					,;
										0						,;
										_dPerda					,;
										_cInvimOk				})
				Else
					lOkEtq	:= .F.
					lRet	:= .F.
				Endif
			Else
				MsgAlert("No es Transferencia Dev. Despacho /Depósito incorrecto!","A T E N C I Ó N")
				cProduto	:= Space(Len(SB1->B1_COD))
				cLote		:= Space(Len(ZZH->ZZH_LOTE))
				cEtiqueta	:= Space(60)
				lRet		:=.F.
				oDlg:Refresh()
				oGetcEtiqueta:Setfocus()
				oGetcEtiqueta:Refresh()			
			Endif
		Endif
		
	Else
		If !Empty(cProduto)
			if Substr(cCombo1,1,1) == "1"
				If MsgYesNo("Producto No existe ! Desea grabar el producto?","A T E N C I Ó N")
					lPrdNotExist:= .T.
				Endif
				lRet:= .f.
			Else
				MsgAlert("Producto no existe en el registro !","A T E N C I Ó N")	
					
				lRet		:= .F.
				cEtiqueta	:= Space(60)	
				cProduto	:= Space(Len(SB1->B1_COD))
				cLote		:= Space(Len(ZZH->ZZH_LOTE))
				oDlg:Refresh()
				oGetcEtiqueta:Refresh()
				oGetcEtiqueta:Setfocus()
			Endif
		Else
			lRet:= .F.
			oDlg:Refresh()
			fWBrowse(oWBrowse1,aWBrowse1,oDlg)
		Endif
	Endif	
	
	If lRet
		cProduto	:= space(Len(SB1->B1_COD))
		cLote		:= space(Len(ZZH->ZZH_LOTE))
		cEtiqueta	:= Space(60)
		oDlg:Refresh()
	Endif
Endif

If lRet
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grabando en tabla ZZH   				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GravaZZH(aWbrowse1, cNumero, cSerie, cClifor, cLoja, cNome, lFiltra, dData, dDtaVal, cAutImp, cItemPv, _cMsgEtq, _cMsgInv)
	
	oDlg:Refresh()
	fWBrowse(oWBrowse1,aWBrowse1,oDlg)
	
	oDlg:Refresh()
	oGetcEtiqueta:Setfocus()
	oGetcEtiqueta:Refresh()
	
Endif

Return//(lRet)


//////////////////////////////////////////////////////////////////////////////////////////////////
//Grava Etiquetas Lidas na Tabela ZZH
//////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaZZH(aWBrowse1, cNumero, cSerie, cClifor, cLoja, cNome, lFiltra, dData, dDtaVal, cAutImp, cItemPv, _cMsgEtq, _cMsgInv)

Local nNumEtq:= 0
Local cResponsavel	:= SuperGetMV("ZZ_RESPON",,"") 
Local cCrea			:= SuperGetMV("ZZ_CREA",,"")
Local nRecZZH		:= 0
Local cTipeB1		:= space(Len(SB1->B1_TIPE))


if Len(aWBrowse1) > 0
	
	For iTens:= Len(aWBrowse1) to Len(aWBrowse1)
	
		if aWBrowse1[iTens,9] = 0
		
			if !Empty(aWBrowse1[iTens,4])
				
				cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + Alltrim(aWBrowse1[iTens,2]) ,"B1_TIPE"))
				
				if Substr(cCombo1,1,1) = "1" //Nota Fiscal de Entrada
					RecLock("ZZH",.t.)
					ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
					ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
					ZZH->ZZH_DOC	:= cNumero
					ZZH->ZZH_SERIE	:= cSerie
					ZZH->ZZH_FORNEC	:= cCliFor
					ZZH->ZZH_LOJA	:= cLoja
					ZZH->ZZH_NOMEF	:= cNome
					ZZH->ZZH_ENTRA	:= dDataBase //dData	
					ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
					ZZH->ZZH_AUTIMP	:= cAutImp	
					ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
					ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
					If Empty(ZZH->ZZH_INVIM1)
						ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
					Else
						ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
					EndIf
					ZZH->ZZH_NOPC	:= "1"
					Msunlock()
					
				elseif Substr(cCombo1,1,1) == "2" // Pedido de Venda
		
					cProduto:= padr(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= padr(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
					
					nRecZZH:= fBuscaEtq(cProduto,cLote)		
					
					if nRecZZH > 0
					
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
						RecLock("ZZH",.f.)
							ZZH->ZZH_PEDIDO	:= cNumero
							ZZH->ZZH_ITEMPV	:= cItemPv
							ZZH->ZZH_CLIENT	:= cClifor
							ZZH->ZZH_LOJAC	:= cLoja
							ZZH->ZZH_NOMEC	:= cNome
							ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2])
							ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
							ZZH->ZZH_SAIDA	:= dDataBase
							ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
							ZZH->ZZH_NOPC	:= "2"
						Msunlock()
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
					endif	
						
				elseif Substr(cCombo1,1,1) = "3"  // Ordem de Produçao Entrada
					RecLock("ZZH",.t.)
					ZZH->ZZH_OP		:= cNumero
					ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
					ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
					ZZH->ZZH_ENTRA	:= dDataBase //dData
					ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
					ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
					ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
					If Empty(ZZH->ZZH_INVIM1)
						ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
					Else
						ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
					EndIf
					Msunlock()
				elseif Substr(cCombo1,1,1) = "4"  // Ordem de Produção Saida
					cNumero := padr(Alltrim(cNumero),tamSx3("ZZH_OP")[1])
					cProduto:= padr(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= padr(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
				
					nRecZZH:= fBuscaEtq(cProduto,cLote)		
				
					if nRecZZH > 0
				
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
						RecLock("ZZH",.f.)
						ZZH->ZZH_OPSAI	:= cNumero
						ZZH->ZZH_SAIDA	:= aWBrowse1[iTens,5]
						ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
						Msunlock()
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
					endif
				elseif Substr(cCombo1,1,1) = "5"  // Movimento Interno Entrada
					RecLock("ZZH",.t.)
					ZZH->ZZH_DOC	:= cNumero
					ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
					ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
					ZZH->ZZH_ENTRA	:= dDataBase //dData
					ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
					ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
					ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
					If Empty(ZZH->ZZH_INVIM1)
						ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
					Else
						ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
					EndIf
					Msunlock()
				elseif Substr(cCombo1,1,1) = "6"  // Movimento Interno Saida
					cNumero := padr(Alltrim(cNumero),tamSx3("ZZH_DOC")[1])
					cProduto:= padr(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= padr(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
				
					nRecZZH:= fBuscaEtq(cProduto,cLote)		
				
					if nRecZZH > 0
				
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
						RecLock("ZZH",.f.)
						ZZH->ZZH_DOCINT	:= cNumero
						ZZH->ZZH_SAIDA	:= aWBrowse1[iTens,5]
						ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
						Msunlock()
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
					endif
				elseif Substr(cCombo1,1,1) = "7" // Devolução de Vendas.
					RecLock("ZZH",.t.)
					ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
					ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
					ZZH->ZZH_DOC	:= cNumero
					ZZH->ZZH_SERIE	:= cSerie
					ZZH->ZZH_CLIENT	:= cCliFor
					ZZH->ZZH_LOJAC	:= cLoja
					ZZH->ZZH_NOMEC	:= cNome
					ZZH->ZZH_ENTRA	:= dDataBase //dData	
					ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
					ZZH->ZZH_AUTIMP	:= cAutImp	
					ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
					ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
					If Empty(ZZH->ZZH_INVIM1)
						ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
					Else
						ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
					EndIf
					Msunlock()
				Elseif Substr(cCombo1,1,1) = "8" // Nota Fiscal de Saída.
					cProduto:= padr(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= padr(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
					
					nRecZZH:= fBuscaEtq(cProduto,cLote)		
					
					if nRecZZH > 0
					
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
						RecLock("ZZH",.f.)
							ZZH->ZZH_CLIENT	:= cClifor
							ZZH->ZZH_LOJAC	:= cLoja
							ZZH->ZZH_NOMEC	:= cNome
							ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
							ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
							ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
							ZZH->ZZH_AUTIMP	:= cAutImp	
							ZZH->ZZH_SAIDA	:= dDataBase  //dData
							ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
							ZZH->ZZH_NFSAID	:= cNumero
							ZZH->ZZH_SERSAI	:= cSerie
						Msunlock()
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
					endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grabando en tabla ZZH -9-Dev. Pedido	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf Substr(cCombo1,1,1) == "9" // Dev. Pedido de Venda
		
					cProduto:= PadR(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= PadR(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
					
					nRecZZH:= fBuscaEtq(cProduto,cLote)
					
					If nRecZZH > 0
						
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
						RecLock("ZZH",.F.)							
							ZZH->ZZH_DEVPED	:= "S"	//Indica que El Pedido ha sido devuelto					
						Msunlock()
													//Registro del Ingreso del "Producto /Lote"
						RecLock("ZZH",.T.)
						ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
						ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
						ZZH->ZZH_DOC	:= cNumero
						ZZH->ZZH_SERIE	:= " "
						ZZH->ZZH_CLIENT	:= cClifor
						ZZH->ZZH_LOJAC	:= cLoja
						ZZH->ZZH_NOMEC	:= cNome
						ZZH->ZZH_ENTRA	:= dDataBase
						ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
					  //ZZH->ZZH_AUTIMP	:= cAutImp	
						ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
						ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
						If Empty(ZZH->ZZH_INVIM1)
							ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
						Else
							ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
						EndIf
						
						ZZH->ZZH_RECPED	:= nRecZZH
						ZZH->ZZH_USER	:= UsrRetName(RetCodUsr())
						ZZH->ZZH_NOPC	:= "9"
						Msunlock()
					Else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
					Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grabando en tabla ZZH -A-Mov. Traspaso	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf Substr(cCombo1,1,1) == "A" // Mov.Interno Traspaso
				
					cProduto:= PadR(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= PadR(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
					
					nRecZZH:= fBuscaEtq(cProduto,cLote)
					
					If nRecZZH > 0
					
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
												
						RecLock("ZZH",.F.)							
							ZZH->ZZH_SAIDA	:= dDataBase	//Indica que El Ingreso ha salido
						Msunlock()
						
						RecLock("ZZH",.T.)
						ZZH->ZZH_DOC	:= cNumero
						ZZH->ZZH_DOCTRF	:= cNumero
						ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
						ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
						ZZH->ZZH_SAIDA	:= dDataBase //dData
						ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
						ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
						ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
						
						If Empty(ZZH->ZZH_INVIM1)
							ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
						Else
							ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
						EndIf
						
						ZZH->ZZH_USER	:= UsrRetName(RetCodUsr())
						ZZH->ZZH_NOPC	:= "A"
													
						Msunlock()
					Else
						MsgAlert("No hay Saldo para Grabar Etiqueta (TRF) !","A T E N C I Ó N")
					Endif					
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grabando en tabla ZZH -B-Mov.int.dev.	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf Substr(cCombo1,1,1) == "B" // Mov.Interno Traspaso (Dev.)
					
					cProduto:= PadR(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= PadR(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])					
					nRecZZH	:= fBuscaEtq(cProduto,cLote)		
					
					If nRecZZH > 0
						
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
												
						RecLock("ZZH",.F.)
							ZZH->ZZH_DEVPED	:= "S"	//Indica que ha sido devuelto
						Msunlock()
					
						RecLock("ZZH",.T.)
						ZZH->ZZH_DOC	:= cNumero
						ZZH->ZZH_DOCDEV	:= cNumero
						ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
						ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
						ZZH->ZZH_ENTRA	:= dDataBase //dData
						ZZH->ZZH_VALID	:= Iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))
						ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
						ZZH->ZZH_PERDA  := aWBRowse1[iTens][10]
						If Empty(ZZH->ZZH_INVIM1)
							ZZH->ZZH_INVIM1 := aWBRowse1[iTens][11]
						Else
							ZZH->ZZH_INVIM2 := aWBRowse1[iTens][11]
						EndIf
						ZZH->ZZH_RECPED	:= nRecZZH
						ZZH->ZZH_USER	:= UsrRetName(RetCodUsr())
						ZZH->ZZH_NOPC	:= "B"
						Msunlock()
					Endif
				Endif
				
				
				
				aWBrowse1[iTens,9]:= ZZH->(Recno())
				
				//if lImpEtq .and. (Substr(cCombo1,1,1) = "1" .or. Substr(cCombo1,1,1) = "3") .and. Substr(cCombo2,1,1) = "1" //.and. !lFiltra
				if Substr(cCombo1,1,1) $ "1/3/5/7" .and. Substr(cCombo2,1,1) = "1" //.and. !lFiltra
					If Empty(ZZH->ZZH_PERDA)
						If !Empty(aWBrowse1[iTens,11])
							U_ETQANVRA(Alltrim(aWBrowse1[iTens,2]) , dDataBase, Alltrim(aWBrowse1[iTens,4]), cCrea, cResponsavel, nNumEtq, Len(aWBrowse1),cIdioma, dDtaVal, cAutImp, cOBLocal, AllTrim(aWBrowse1[iTens,11]))
						Else
							MsgAlert(_cMsgInv, 'Alerta')
						EndIf
					Else
						MsgAlert(_cMsgEtq, 'Alerta')
					EndIf
				endif
				
			endif
		endif		
	Next iTens
endif

Return



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldLote(lOkEtq,cEtiqueta,cProduto,cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp, _cMsgEtq, _cMsgInv)

Local lLote			:= .f.
Local cMesAt		:= ""
Local nRecNoExist	:= 0
Local _dPerda       := CToD('//')
Local _cInvim1      := ''

if Empty(cLote)

	if cIdioma == "SPANISH"
		cMsgAviso := Upper("Haga la lectura del lote.") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += Upper("Si desea abandonar esta lectura, haga clic en 'Sí' ") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += Upper("Si desea leer una etiqueta con el lote, haga clic en 'NO' ") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += " " + CRLF
		cMesAt:= "A T E N C I Ó N"
	
	elseif cIdioma == "ENGLISH"
		cMsgAviso := Upper("Do the Lot Read.") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += Upper("If you wish to abandon this reading, click on 'YES' ") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += Upper("If you want to read a label with the Batch, click 'NO' ") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += " " + CRLF
		cMesAt:= "A T T E N T I O N"
	else
		cMsgAviso := Upper("Faça a Leitura do Lote.") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += Upper("Se deseja abandonar essa leitura, clique em 'SIM' ") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += Upper("Se deseja ler uma etiqueta com o Lote, clique em 'NÃO' ") + CRLF
		cMsgAviso += " " + CRLF
		cMsgAviso += " " + CRLF
		cMesAt:= "A T E N Ç Ã O"
	endif	

	
	If MsgYesNo(cMsgAviso,cMesAt)
		lLote	:= .t.
		lOkEtq	:= .t.
		cProduto	:= space(Len(SB1->B1_COD))
		cLote		:= space(Len(ZZH->ZZH_LOTE))
		cEtiqueta	:= Space(60)
	endif	
else
	if Alltrim(cLote) == Alltrim(Substr(cProduto,1,Len(ZZH->ZZH_LOTE))) 
		if !Empty(cLote) .and. !Empty(cProduto)
			msgAlert("Lote no puede ser igual al Código de Producto !","A T E N C I Ó N")
		endif	
		lLote	:= .t.
		lOkEtq	:= .t.
		cLote:= space(Len(ZZH->ZZH_LOTE))
		cProduto	:= space(Len(SB1->B1_COD))
		cEtiqueta	:= Space(60)
		oGetcEtiqueta:Setfocus()
		oGetcEtiqueta:Refresh()
	else
		if lPrdNotExist

			nRecNoExist:= GrvNotExist( cNumero, cSerie, cClifor, cLoja, cNome, cProduto , dData, cLote)
			
			Aadd(aWBrowse1,	{	.f.						,;
				cProduto								,;
				"******** No hay registro *********" 	,;
				cLote									,;
				dDataBase								,;
				cCliFor									,;
				cLoja									,;
				cNome									,;
				nRecNoExist								,;
				_dPerda									,;
				_cInvim1								})
			
			cProduto	:= space(Len(SB1->B1_COD))
			cLote		:= space(Len(ZZH->ZZH_LOTE))
			cEtiqueta	:= Space(60)
			oGetcEtiqueta:Setfocus()
			oGetcEtiqueta:Refresh()
			lPrdNotExist:= .f.
		else	
			cEtiqueta:= Alltrim(cProduto) + "|" + Alltrim(cLote)
			fVldEtq(lOkEtq,cEtiqueta,cProduto,cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lFiltra, dData, dDtaVal, cAutImp, _cMsgEtq, _cMsgInv)
			cProduto	:= space(Len(SB1->B1_COD))
			cLote		:= space(Len(ZZH->ZZH_LOTE))
			cEtiqueta	:= Space(60)
			lOkEtq		:= .t.
			oGetcEtiqueta:Setfocus()
			oGetcEtiqueta:Refresh()
		endif
	endif		
endif

oDlg:Refresh()
fWBrowse(oWBrowse1,aWBrowse1,oDlg)

Return//(lLote)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fQryPed(cNumero,cProduto,aItemPV,cItemPv)

Local lPed		:= .t.
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local lAchouPv	:= .t.
Local lExecQry	:= .t.
//Local cItem		:= ""
Local nQtdLib	:= 0
Local nQtdRas	:= 0
Local lSaldo	:= .t.
																			
nPos := aScan(aItemPv, {|x| x[1] == cProduto .and. x[2] == cNumero })
if nPos = 0
	lAchouPv:= .f.
else
	if aItemPv[nPos,4] = 0
//		if Empty(cItem)
//			cItem:= "'"+aItemPv[nPos,3]+"'"
//		else
			cItem := StrTran(Alltrim(aItemPv[nPos,5]),"/","','")
			cItem := "'"+cItem+"'"
		
			//cItem+= "," + "'"+aItemPv[nPos,3]+"'"
//		endif*/
			 
		//msgAlert("ITEM: "+cItem)
		//aDel(aItemPv,nPos)
		//ASize(aItemPv, Len(aItemPv)-1 )
	else
		nQtdLib:= fVldQtd(cNumero,cProduto,"")
		nQtdRas:= fVldRas(cNumero,cProduto)
		
		if nQtdLib > nQtdRas
			aItemPv[nPos,4]-= 1
			cItemPv:= aItemPv[nPos,3]
		else
			lSaldo:= .f.
		endif	
		lExecQry:= .f.
	endif	
endif

 if lExecQry

	If Select(cAlias) > 0
		(cAlias)->(DbCloseArea())
	EndIf
	
	cQuery:= " SELECT C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9_NFISCAL, C9_QTDLIB "+CRLF 
	cQuery+= " FROM " + RetSqlName( "SC9" ) + "  "+CRLF
	cQuery+= " WHERE C9_FILIAL  = '"+ xFilial("SC9")+ "'	AND "+CRLF
	cQuery+= "       C9_PEDIDO	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       C9_PRODUTO = '"+cProduto+"'			AND "+CRLF
	if lAchouPv
		cQuery+= "   C9_ITEM NOT IN (" + cItem + ")			AND "+CRLF
	endif	
	cQuery+= "       D_E_L_E_T_ = ' '  		                    "+CRLF
	cQuery+= " ORDER BY C9_PEDIDO, C9_ITEM, C9_PRODUTO	"		 +CRLF
	
	TcQuery cQuery New Alias &cAlias
	
	if (cAlias)->(Eof())
	
		if !lAchouPv
			if cIdioma == "SPANISH"
				msgAlert("Producto no existe en el pedido o no ha sido liberado !","A T E N C I Ó N")	
			elseif cIdioma == "ENGLISH"
				msgAlert("Product Not in Order or Not Released !","A T T E N T I O N")	
			else
				msgAlert("Produto Não existe no Pedido ou Não foi Liberado !","A T E N Ç Ã O")	
			endif
		else
			if cIdioma == "SPANISH"
				msgAlert("El saldo de pedido para este artículo ya se ha cumplido !","A T E N C I Ó N")	
			elseif cIdioma == "ENGLISH"
				msgAlert("Product has no balance left !","A T T E N T I O N")	
			else
				msgAlert("Saldo do Pedido pra esse item já foi atendido !","A T E N Ç Ã O")	
			endif
		endif		
		lPed:= .f.
	else
		if !lAchouPv
			Aadd(aItemPv,{	cProduto						,; //01
							cNumero							,; //02
							(cAlias)->C9_ITEM				,; //03
							(cAlias)->C9_QTDLIB	- 1			,; //04
							(cAlias)->C9_ITEM 				}) //05  //GUARDO TODOS OS ITENS LIDOS DO PRODUTO
		else
			aItemPv[nPos,3]:= (cAlias)->C9_ITEM
			aItemPv[nPos,4]:= (cAlias)->C9_QTDLIB	- 1
			aItemPv[nPos,5]+= "/" + (cAlias)->C9_ITEM
		endif
		cItemPv:= (cAlias)->C9_ITEM						
	endif
else
	if !lSaldo
		if cIdioma == "SPANISH"
			msgAlert("El saldo de pedido para este artículo ya se ha cumplido !","A T E N C I Ó N")	
		elseif cIdioma == "ENGLISH"
			msgAlert("Product has no balance left !","A T T E N T I O N")	
		else
			msgAlert("Saldo do Pedido pra esse item já foi atendido !","A T E N Ç Ã O")	
		endif
		lPed:= .f.
	endif		
endif

Return(lPed)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldDoc(oDlg,cNumero,cSerie,_cSRemito)

Local lRetDoc:= .t.

if Substr(cCombo1,1,1) = "1" // Nota de Entrada
	cNumero := padr(Alltrim(cNumero),tamSx3("D1_DOC")[1])
	SF1->(dbSetOrder(1))
	If !SF1->(dbSeek(xFilial("SF1")+cNumero+cSerie))
		if cIdioma == "SPANISH"
			msgAlert("Nota Fiscal no encontrada !","A T E N C I Ó N")	
		elseif cIdioma == "ENGLISH"
			msgAlert("Invoice not found !","A T T E N T I O N")		
		else
			msgAlert("Nota Fiscal não encontrada !","A T E N Ç Ã O")		
		endif	
		cNumero	:= Space(13)//space(Len(SF1->F1_DOC))
		cSerie	:= space(Len(SF1->F1_SERIE))
		lRetDoc:= .f.
	endif	
elseif Substr(cCombo1,1,1) = "2"
	cNumero := padr(Alltrim(cNumero),tamSx3("C5_NUM")[1])
	SC5->(dbSetOrder(1))
	If !SC5->(dbSeek(xFilial("SC5")+Alltrim(cNumero)))
		if cIdioma == "SPANISH"
			msgAlert("Solicitud de venta no encontrada !","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Sales Order not found !","A T T E N T I O N")
		else
			msgAlert("Pedido de Venda não encontrado !","A T E N Ç Ã O")
		endif	
		cNumero	:= Space(13)//space(Len(SF1->F1_DOC))
		lRetDoc:= .f.
	endif
elseif Substr(cCombo1,1,1) = "3"
	cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
	SC2->(dbSetOrder(1))
	If !SC2->(dbSeek(xFilial("SC2")+Alltrim(cNumero)))
		if cIdioma == "SPANISH"
			msgAlert("Orden de producción no encontrado !","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Production order not found !","A T T E N T I O N")
		else
			msgAlert("Ordem de Produção não encontrado !","A T E N Ç Ã O")		
		endif		
		cNumero	:= space(13) //space(Len(SF1->F1_DOC))
		lRetDoc:= .f.
	endif
ElseIf SubStr(cCombo1, 1, 1) = "8" // Nota Fiscal de Saída.
	cNumero := PadR(AllTrim(cNumero), TamSx3("D2_DOC")[1])
	SF2->(DBSetOrder(1)) // Indice 1 - F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	If !SF2->(DBSeek(xFilial("SF2")+cNumero+cSerie))
		If cIdioma == "SPANISH"
			MsgAlert("Factura no encontrada !","A T E N C I Ó N")	
		ElseIf cIdioma == "ENGLISH"
			MsgAlert("Outgoing Invoice not found !","A T T E N T I O N")		
		Else
			MsgAlert("Nota fiscal de saída não encontrada !","A T E N Ç Ã O")		
		EndIf	
		cNumero	:= Space(13)
		cSerie	:= space(Len(SF2->F2_SERIE))
		lRetDoc:= .f.
	Else
		If !(AllTrim(SF2->F2_SERIE) $ _cSRemito)
			If cIdioma == "SPANISH"
				MsgAlert("Factura no es un Remito !","A T E N C I Ó N")	
			ElseIf cIdioma == "ENGLISH"
				MsgAlert("Sales order is not a Remito !","A T T E N T I O N")		
			Else
				MsgAlert("Documento não é um Remito !","A T E N Ç Ã O")		
			EndIf	
			cNumero	:= Space(13)
			cSerie	:= space(Len(SF2->F2_SERIE))
			lRetDoc:= .f.
		EndIf
	EndIf

/*
ElseIf SubStr(cCombo1, 1, 1) == "A" // Mov.Interno de Traspaso
	cNumero := PadR(AllTrim(cNumero), TamSx3("D3_DOC")[1])
	SD3->(DBSetOrder(2))
	If !SD3->(DBSeek(xFilial("SD3")+cNumero))
		If cIdioma == "SPANISH"
			MsgAlert("Mov.Interno de Traspaso no encontrada !","A T E N C I Ó N")	
		ElseIf cIdioma == "ENGLISH"
			MsgAlert("not found !","A T T E N T I O N")		
		Else
			MsgAlert("Mov.interno de traspaso não encontrada !","A T E N Ç Ã O")		
		EndIf	
		cNumero	:= Space(13)
		cSerie	:= Space(Len(SF2->F2_SERIE))
		lRetDoc	:= .F.	
	EndIf
*/	
Endif
	
Return(lRetDoc)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Edita Campos  (Lote)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fvalEdit(oDlg, oWBrowse1, aWBrowse1)
	                    
	Local lRetBrw		:= .t.
	Local cMensBlq	:= ""

	if oWBrowse1:ColPos <> 1
		aWBrowse1[oWBrowse1:nAt,1]:= .f.
	endif	

	if oWBrowse1:ColPos = 4
			
		lEditCell(aWBrowse1, oWBrowse1, PesqPict("ZZH","ZZH_LOTE"), oWBrowse1:ColPos) 
		
		If Empty(aWbrowse1[oWBrowse1:nAt,4])  
			if cIdioma == "SPANISH"
				cMensBlq:= "Informe del lote !" + CRLF
				cMensBlq:= "Este registro no se grabará." + CRLF
				cMensBlq+= ""+CRLF
				msgAlert(cMensBlq,"A T E N C I Ó N")
			elseif cIdioma == "ENGLISH"
				cMensBlq:= "Report Lot !" + CRLF
				cMensBlq:= "This Record Will Not Be Recorded." + CRLF
				cMensBlq+= ""+CRLF
				msgAlert(cMensBlq,"A T T E N T I O N")
			else
				cMensBlq:= "Informe o Lote !" + CRLF
				cMensBlq:= "Esse Registro Não será gravado." + CRLF
				cMensBlq+= ""+CRLF
				msgAlert(cMensBlq,"A T E N Ç Ã O")
			endif	
			lRetBrw:= .f.
		endif
		aWBrowse1[oWBrowse1:nAt,1]:= .f.
	endif
	
	oWBrowse1:Refresh()			// Refresh do Grid
	oDlg:Refresh() 
	
Return ( lRetBrw )


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Deleta ítens
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDeletaItem(aWBrowse1, oWBrowse1, oDlg, lFiltra, cCombo, cNumero, cSerie, cCliFor, cLoja)

Local aWBrAux:= {}

If SubStr(cCombo1, 1, 1) $ "A|B"
	cMensBlq:= "No permitido Eliminar el Registro."
	MsgAlert(cMensBlq,"A T E N C I Ó N")
	Return
Endif

For i:= 1 to Len(aWBrowse1)

	If !aWBrowse1[i,1]
		Aadd(aWBrAux,	{	.f.				,;
							aWBrowse1[i,2]	,;
							aWBrowse1[i,3]	,;
							aWBrowse1[i,4]	,;
							aWBrowse1[i,5]	,;
							aWBrowse1[i,6]	,;
							aWBrowse1[i,7]	,;
							aWBrowse1[i,8]	,;
							aWBrowse1[i,9]	,;
							aWBrowse1[i,10]	,;
							aWBrowse1[i,11]	})
	Else
	
		fExclui(cCombo, aWBrowse1[i,9])		
	Endif
	
Next i

aWBRowse1:= {}
fWBrowse(oWBrowse1,aWBrowse1,oDlg)

aWBRowse1:= aClone(aWBrAux)

oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

fWBrowse(oWBrowse1,aWBrowse1,oDlg)

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Valida Numero digitado. Somente para Pedido de Venda e Ordem de Produção, pois para Nota Fiscal de Entrada já está
//validando no campo Série.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldNum(oDlg,cNumero,cClifor, cLoja, cNome, dData, oWBrowse1, oDlg , aWBrowse1, lFiltra)

Local lRetNum:= .T.
Local lAchou := .F.

if  Substr(cCombo1,1,1) = "2" // Pedido de Venda
	SC9->(dbSetOrder(1))
	If !SC9->(dbSeek(xFilial("SC9")+Alltrim(cNumero)))
		if cIdioma == "SPANISH"
			msgAlert("Solicitud de venta no ha sido liberado !","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Sales order was not released !","A T T E N T I O N")
		else
			msgAlert("Pedido de Venda não foi Liberado !","A T E N Ç Ã O")
		endif	
		cNumero	:= space(13) //space(Len(SF1->F1_DOC))
		lRetNum:= .f.
	else
		SA1->(dbSetOrder(1))
		if SA1->(dbSeek(xFilial("SA1")+SC9->(C9_CLIENTE+C9_LOJA)))
			cCliFor	:= SC9->C9_CLIENTE
			cLoja	:= SC9->C9_LOJA
			cNome	:= Alltrim(SA1->A1_NOME)
			dData	:= SC9->C9_DATALIB
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1) , cNumero, "", cCliFor, cLoja, "", @lFiltra)
		endif	
	endif	
elseif  Substr(cCombo1,1,1) = "3" .or. Substr(cCombo1,1,1) = "4" // Ordem de Produção Entrada # ENTRADA #SAIDA
	if  Substr(cCombo1,1,1) = "3"
		cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
		SD3->(dbSetOrder(1))
		if SD3->(dbSeek(xFilial("SD3")+cNumero))
			lAchou:= .t.
			dData:= SD3->D3_EMISSAO	
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1), cNumero, "", cCliFor, cLoja, "", @lFiltra)
		endif
	else
		cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
		SD4->(dbSetOrder(2))
		if SD4->(dbSeek(xFilial("SD4")+cNumero))
			lAchou:= .t.
			dData:= SD4->D4_DATA
			fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1), cNumero, "", cCliFor, cLoja, "", @lFiltra)	
		endif
	endif	
	if !lAchou
		if cIdioma == "SPANISH"
			msgAlert("Orden de Producción informado No encontrado!","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Informed Production Order Not Found!","A T T E N T I O N")		
		else
			msgAlert("Ordem de Produção informado Não encontrada!","A T E N Ç Ã O")		
		endif	
		lRetNum:= .f.
	endif
elseif  Substr(cCombo1,1,1) = "5" .or. Substr(cCombo1,1,1) = "6" // Movimento Interno # ENTRADA #SAIDA
	if  Substr(cCombo1,1,1) = "5"
		cNumero := padr(Alltrim(cNumero),tamSx3("D3_DOC")[1])
		SD3->(dbSetOrder(2))
		if SD3->(dbSeek(xFilial("SD3")+cNumero))
			While !SD3->(Eof()) .and. SD3->D3_DOC == cNumero
				if SubStr(SD3->D3_CF,1,1) == "D"  .and. Empty(SD3->D3_ESTORNO)
					lAchou:= .t.
					dData:= SD3->D3_EMISSAO	
					fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1), cNumero, "", "", "", "", @lFiltra)
					exit
				endif
				SD3->(dbSkip())
			enddo		
		endif
	else
		cNumero := padr(Alltrim(cNumero),tamSx3("D3_DOC")[1])
		SD3->(dbSetOrder(2))
		if SD3->(dbSeek(xFilial("SD3")+cNumero))
			While !SD3->(Eof()) .and. SD3->D3_DOC == cNumero
				if SubStr(SD3->D3_CF,1,1) == "R" .and. Empty(SD3->D3_ESTORNO)
					lAchou:= .t.
					dData:= SD3->D3_EMISSAO	
					fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1), cNumero, "", "", "", "", @lFiltra)
					exit
				endif
				SD3->(dbSkip())
			enddo		
		endif
	endif	
	if !lAchou
		if cIdioma == "SPANISH"
			msgAlert("Documento informado No encontrado!","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Document Not Found!","A T T E N T I O N")		
		else
			msgAlert("Documento informado Não encontrada!","A T E N Ç Ã O")		
		endif	
		lRetNum:= .f.
	endif
	
/****************/

ElseIf  Substr(cCombo1,1,1) == "A" // Mov.Interno Traspaso
	cNumero := Padr(Alltrim(cNumero),TamSx3("D3_DOC")[1])
	SD3->(dbSetOrder(2))
	If SD3->(dbSeek(xFilial("SD3")+cNumero))
		lAchou 	:= .T.
		dData	:= SD3->D3_EMISSAO	
		fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1), cNumero, "", cCliFor, cLoja, "", @lFiltra)
	Endif	
	
	If !lAchou
		If cIdioma == "SPANISH"
			msgAlert("Mov. Interno de Traspaso informado No encontrado!","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Document Not Found!","A T T E N T I O N")		
		else
			msgAlert("Mov. Interno de Traspaso Não encontrado!","A T E N Ç Ã O")		
		Endif	
		lRetNum:= .f.
	Endif

/****************/

ElseIf  Substr(cCombo1,1,1) == "B" // Mov.Interno Traspaso -Devolución
	cNumero := Padr(Alltrim(cNumero),TamSx3("D3_DOC")[1])
	SD3->(dbSetOrder(2))
	If SD3->(dbSeek(xFilial("SD3")+cNumero))
		lAchou 	:= .T.
		dData	:= SD3->D3_EMISSAO	
		fFiltrar(@aWBrowse1, oWBrowse1, oDlg, Substr(cCombo1,1,1), cNumero, "", cCliFor, cLoja, "", @lFiltra)
	Endif	
	
	If !lAchou
		If cIdioma == "SPANISH"
			msgAlert("Mov. Interno de Traspaso informado No encontrado!","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Document Not Found!","A T T E N T I O N")		
		else
			msgAlert("Mov. Interno de Traspaso Não encontrado!","A T E N Ç Ã O")		
		Endif	
		lRetNum:= .f.
	Endif	
Endif

oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

Return(lRetNum)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Filtra Ítens da Nota Fiscal Lidos anteriormente
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fFiltrar(aWBrowse1, oWBrowse1, oDlg, cCombo, cNumero, cSerie, cCliFor, cLoja, lOkEtq, lFiltra)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local cCodigo	:= ""
Local cCodLoj	:= ""
Local cNome		:= ""
Local nQtdLiberada:= 0

/*if Len(aWBrowse1) > 0
	Return
endif*/

aWBrowse1:= {}
	
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQuery:= " SELECT ZZH_COD, ZZH_DESC, ZZH_ENTRA, ZZH_LOTE, ZZH_FORNEC, ZZH_LOJA, ZZH_PEDIDO, ZZH_ITEMPV, "+CRLF
cQuery+= "        ZZH_NOMEF, ZZH_CLIENT, ZZH_LOJAC, ZZH_NOMEC, ZZH_NUMETQ, ZZH_PERDA, ZZH_INVIM1, R_E_C_N_O_ "+CRLF 
cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF

if cCombo = "1" //Nota Fiscal de Entrada
	cQuery+= "       ZZH_DOC		= '"+cNumero+"'			AND "+CRLF
	cQuery+= "       ZZH_SERIE	= '"+cSerie+"'				AND "+CRLF
	cQuery+= "       ZZH_FORNEC	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJA	= '"+cLoja+"'				AND "+CRLF
elseif cCombo = "2" //Pedido de Venda	
	cQuery+= "       ZZH_PEDIDO	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_CLIENT	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJAC	= '"+cLoja+"'				AND "+CRLF
elseif cCombo = "3"  //Ordem de Produção Entrada
	cQuery+= "       ZZH_OP = '"+cNumero+"'					AND "+CRLF
elseif cCombo = "4"  //Ordem de Produção Saida
	cQuery+= "       ZZH_OPSAI = '"+cNumero+"'				AND "+CRLF
elseif cCombo = "5"  //Movimento Interno Entrada
	cQuery+= "       ZZH_DOC = '"+cNumero+"'				AND "+CRLF
elseif cCombo = "6"  //Movimento Interno Saida
	cQuery+= "       ZZH_DOCINT = '"+cNumero+"'				AND "+CRLF
elseif cCombo = "7" // Devolução de vendas.
	cQuery+= "       ZZH_DOC	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_SERIE	= '"+cSerie+"'				AND "+CRLF
	cQuery+= "       ZZH_FORNEC	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJA	= '"+cLoja+"'				AND "+CRLF
elseif cCombo = "8" // Nota fiscal de saída.
	cQuery+= "       ZZH_DOC	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_SERIE	= '"+cSerie+"'				AND "+CRLF
	cQuery+= "       ZZH_FORNEC	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJA	= '"+cLoja+"'				AND "+CRLF
	
Elseif cCombo = "9" // Dev. Pedido Venta
	cQuery+= "       ZZH_PEDIDO	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_CLIENT	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJAC	= '"+cLoja+"'				AND "+CRLF
  //cQuery+= "       ZZH_RECPED	> 0							AND "+CRLF
	cQuery+= "       ZZH_NOPC	= '9'						AND "+CRLF

Elseif cCombo = "A" // Mov.Interno Traspaso
	cQuery+= "       ZZH_DOCTRF	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_NOPC	= 'A'						AND "+CRLF
	
Elseif cCombo = "B" // Mov.Interno Traspaso
	cQuery+= "       ZZH_DOCTRF	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_NOPC	= 'B'						AND "+CRLF

Endif
cQuery+= " D_E_L_E_T_ = ' '  		                  			"+CRLF

TcQuery cQuery New Alias &cAlias

TCSetField( (cAlias), "ZZH_ENTRA"	, "D")
TCSetField( (cAlias), "ZZH_PERDA"	, "D")

(cAlias)->(dbGotop())

While !(cAlias)->(eof())

	if cCombo = "1" 
		cCodigo	:= (cAlias)->ZZH_FORNEC
		cCodLoj	:= (cAlias)->ZZH_LOJA
		cNome	:= (cAlias)->ZZH_NOMEF
	elseif cCombo = "2"	
		cCodigo	:= (cAlias)->ZZH_CLIENT
		cCodLoj	:= (cAlias)->ZZH_LOJAC
		cNome	:= (cAlias)->ZZH_NOMEC
	elseif cCombo = "3"
		cCodigo	:= (cAlias)->ZZH_FORNEC
		cCodLoj	:= (cAlias)->ZZH_LOJA
		cNome	:= (cAlias)->ZZH_NOMEF
	endif	
	 	
	Aadd(aWBrowse1,	{	.F.							,;
						(cAlias)->ZZH_COD			,;
						Alltrim((cAlias)->ZZH_DESC)	,;
						(cAlias)->ZZH_LOTE			,;
						(cAlias)->ZZH_ENTRA			,;
						cCodigo						,;
						cCodLoj						,;
						cNome						,;
						(cAlias)->R_E_C_N_O_		,;
						(cAlias)->ZZH_PERDA			,;
						(cAlias)->ZZH_INVIM1		})
						
	if cCombo = "2" //PEDIDO DE VENDA
		nPos := aScan(aItemPv, {|x| x[1] == (cAlias)->ZZH_COD .and. x[2] == (cAlias)->ZZH_PEDIDO })
		if nPos = 0
			nQtdLiberada:= fVldQtd((cAlias)->ZZH_PEDIDO,(cAlias)->ZZH_COD,(cAlias)->ZZH_ITEMPV)
			Aadd(aItemPv,{	(cAlias)->ZZH_COD				,; //01
							(cAlias)->ZZH_PEDIDO			,; //02
							(cAlias)->ZZH_ITEMPV			,; //03
							nQtdLiberada - 1				,; //04
							(cAlias)->ZZH_ITEMPV			}) //05  //GUARDO TODOS OS ITENS LIDOS DO PRODUTO
		else
			aItemPv[nPos,4]-= 1 
			if !(cAlias)->ZZH_ITEMPV $ aItemPv[nPos,5]
				aItemPv[nPos,5]+= "/" + (cAlias)->ZZH_ITEMPV
			endif	
		endif
	
	endif

	(cAlias)->(dbSkip())
enddo	

if Len(aWBrowse1) > 0
	//lOkEtq	:= .f.
	lFiltra	:= .t.
endif	
	

fWBrowse(oWBrowse1,aWBrowse1,oDlg)
oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Exclui Registro ZZH
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fExclui(cCombo, nNumRec )

if cCombo = "1" .or. cCombo = "3"	
	dbSelectArea("ZZH")
	ZZH->(dbGoto(nNumRec))
	Reclock("ZZH", .f.)
	ZZH->(dbdelete())
	ZZH->(MSUnlock())
elseif cCombo = "2" 	
	dbSelectArea("ZZH")
	ZZH->(dbGoto(nNumRec))
	Reclock("ZZH", .f.)
	ZZH->ZZH_PEDIDO	:= ""
	ZZH->ZZH_ITEMPV	:= ""
	ZZH->ZZH_CLIENT	:= ""
	ZZH->ZZH_LOJAC	:= ""
	ZZH->ZZH_NOMEC	:= ""
	ZZH->ZZH_SAIDA	:= CTOD("  /  /  ")
	ZZH->(MSUnlock())
elseif cCombo = "4"
	dbSelectArea("ZZH")
	ZZH->(dbGoto(nNumRec))
	Reclock("ZZH", .f.)
	ZZH->ZZH_OP		:= ""
	ZZH->ZZH_SAIDA	:= CTOD("  /  /  ")
	ZZH->(MSUnlock())
endif	

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Busca última seqência de Etiqueta
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fBuscaEtq(cProduto, cLote)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nRec		:= 0

	
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQuery:= " SELECT R_E_C_N_O_   "+CRLF
cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF
if  Substr(cCombo1,1,1) = "2" 		//Pedido de Venda 	//BUSCA QUE NO TENGA PEDIDO
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
elseif  Substr(cCombo1,1,1) = "4"  	//Ordem de Produção Saida
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_OPSAI 	= ''						AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
elseif  Substr(cCombo1,1,1) = "6"  	//Movimento Interno Saida
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_DOCINT	= ''						AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
elseif  Substr(cCombo1,1,1) = "1"  	//Entrada
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
elseif  Substr(cCombo1,1,1) = "7"  	// Devolução de Vendas.
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
elseif  Substr(cCombo1,1,1) = "8"  	// Nota Fiscal de Saída.
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_NFSAID	= ''						AND "+CRLF
ElseIf  Substr(cCombo1,1,1) == "9"  // Dev. Pedido Venta	//BUSCA QUE TENGA SALIDA
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_SAIDA	<> ' '						AND "+CRLF
	cQuery+= "       ZZH_DEVPED	<> 'S'						AND "+CRLF

ElseIf  Substr(cCombo1,1,1) == "A"  // Transferencia		//BUSCA QUE HAYA SALDO
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
	cQuery+= "       ZZH_SAIDA	= ''						AND "+CRLF	
	cQuery+= "      (ZZH_NOPC<>'A' )						AND "+CRLF
	//cQuery+= "     ZZH_DOCTRF<>'' 						AND "+CRLF
ElseIf  Substr(cCombo1,1,1) == "B"  // Dev. Transferencia	//BUSCA QUE DEVOL.
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF	
	cQuery+= "     	 ZZH_DOCTRF<>' ' 						AND "+CRLF
	cQuery+= "     	 ZZH_DOCTRF<>'S' 						AND "+CRLF
EndIf
cQuery+= " D_E_L_E_T_ = ' '  		                   			"+CRLF

TcQuery cQuery New Alias &cAlias

if !(cAlias)->(Eof())
	nRec:= (cAlias)->R_E_C_N_O_
endif	

Return(nRec)


Static Function GrvNotExist( cNumero, cSerie, cClifor, cLoja, cNome, cProduto , dData, cLote)

if  Substr(cCombo1,1,1) = "1" //Nota Fiscal de Entrada
	RecLock("ZZH",.t.)
	ZZH->ZZH_COD	:= cProduto 
	ZZH->ZZH_DESC	:= "******** No hay registro *********"
	ZZH->ZZH_DOC	:= cNumero
	ZZH->ZZH_SERIE	:= cSerie
	ZZH->ZZH_FORNEC	:= cCliFor
	ZZH->ZZH_LOJA	:= cLoja
	ZZH->ZZH_NOMEF	:= cNome
	ZZH->ZZH_ENTRA	:= dDataBase //dData	
	ZZH->ZZH_LOTE	:= cLote
	ZZH->ZZH_NUMETQ	:= ""
	Msunlock()
endif

Return(ZZH->(RECNO()) )


/*
Reimpressão da Etiqueta
*/
Static Function fImprime(aWBrowse1,lFiltra,dDtaVal,cAutImp,_cMsgEtq,_cMsgInv)

//if lImpEtq .and.  (Substr(cCombo1,1,1) = "1" .or.  Substr(cCombo1,1,1) = "3") //.and. !lFiltra
if Substr(cCombo1,1,1) $ "1/3/5/7" //.or.  Substr(cCombo1,1,1) = "3") //.and. !lFiltra
	For x:= 1 to Len(aWBrowse1)
		if aWBrowse1[x,1]
			nReg := fBuscaEtq(Alltrim(aWBrowse1[x,2]),Alltrim(aWBrowse1[x,4]))
			if nReg > 0
				dbSelectArea("ZZH")
				dbGoto(nReg)
				If Empty(aWBrowse1[x,10])
					If !Empty(aWBrowse1[x,11])
						U_ETQANVRA(Alltrim(aWBrowse1[x,2]) , ZZH->ZZH_ENTRA, Alltrim(aWBrowse1[x,4]),"" ,"" ,0 ,0 , cIdioma, dDtaVal,cAutImp,cOBLocal,AllTrim(aWBrowse1[x,11]))
					Else
						MsgAlert(_cMsgInv, 'Alerta')
					EndIf
				Else
					MsgAlert(_cMsgEtq, 'Alerta')
				EndIf
			endif
		endif	
	Next x
else
	msgAlert("Impresión de etiquetas sólo para entradas !","A T E N C I Ó N")	
endif

Return

/* 
*/
/*static function marcaTodos(aWBrowse1)
	local i := 0

	if nMarcado == .T.
		for i := 1 to len(aWBrowse1)
			aWBrowse1[i,1] := .F.
		next i 
		nMarcado    := .F.
	else
		for i := 1 to len(aWBrowse1)
			aWBrowse1[i,1] := .T.
		next i 
		nMarcado    := .T.
	endif
return*/

*****************************************************************************************************************************
Static Function marcaTodos(aWBrowse1,oWBrowse1,lChk,oDlg)

	For x := 1 to Len(aWBrowse1)
		If lChk
			aWBrowse1[x][1] := .T.
		Else
			aWBrowse1[x][1] := .F.
		EndIf
	Next x
	oWBrowse1:Refresh()

Return

 
 
 /*
 */
 Static Function fVldQtd(cNumero,cProduto,cItemPed)
 
 Local nQuantLib:= 0
 Local cAliasC9	:= GetNextAlias()


	If Select(cAliasC9) > 0
		(cAliasC9)->(DbCloseArea())
	EndIf
 
 	cQuery:= " SELECT SUM(C9_QTDLIB) QTDLIB "+CRLF 
	cQuery+= " FROM " + RetSqlName( "SC9" ) + "  "+CRLF
	cQuery+= " WHERE C9_FILIAL  = '"+ xFilial("SC9")+ "'	AND "+CRLF
	cQuery+= "       C9_PEDIDO	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       C9_PRODUTO = '"+cProduto+"'			AND "+CRLF
	if !Empty(cItemPed)
		cQuery+= "   C9_ITEM = '"+cItemPed+"'				AND "+CRLF
	endif
	cQuery+= "       D_E_L_E_T_ = ' '  		                    "+CRLF
	
	TcQuery cQuery New Alias &cAliasC9
	
	if !(cAliasC9)->(Eof())
		nQuantLib:= (cAliasC9)->QTDLIB
	endif	
 
 Return(nQuantLib)
 
/*
 */
 Static Function fVldRas(cNumero,cProduto)
 
 Local nQuantReg:= 0
 Local cAliasZZH:= GetNextAlias()


	If Select(cAliasZZH) > 0
		(cAliasZZH)->(DbCloseArea())
	EndIf
 
 	cQuery:= " SELECT Count(*) QTDREG "+CRLF 
	cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
	cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_COD 	= '"+cProduto+"'			AND "+CRLF
	cQuery+= "       ZZH_DEVPED <> 'S'						AND "+CRLF
	cQuery+= "       D_E_L_E_T_ = ' '  		                    "+CRLF
	
	TcQuery cQuery New Alias &cAliasZZH
	
	if !(cAliasZZH)->(Eof())
		nQuantReg:= (cAliasZZH)->QTDREG
	endif	
 
 Return(nQuantReg)
 
 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Replica ítens
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fReplicar(aWBrowse1, oWBrowse1, oDlg ,cNumero, cSerie, cClifor, cLoja, cNome, dData, dDtaVal, cAutImp, cCombo)

Local aWBrAux:= {}
Local aParamBox	:= {}
Local cPerg		:= "REPLI"
Local cPar01	:= ""
Local cMens01	:= ""
Local cMens02	:= ""
Local cMens03	:= ""
Local cTipeB1	:= space(Len(SB1->B1_TIPE))
Local nIt		:= 0

if cIdioma == "SPANISH"
	cPar01	:= "Cantidad a Replicar"
	cMens01	:= "Copie las etiquetas de cantidad reportada"
	cMens02	:= "Utilizado solo para facturas entrantes !"
	cMens03	:= "No puede tener más de una línea marcada !" 
elseif cIdioma == "ENGLISH"
	cPar01	:= "Quantity to Replicate"
	cMens01	:= "Copy labels of reported quantity"
	cMens02	:= "Used for Incoming Invoices Only !"
	cMens03	:= "Cannot have more than one line marked !"
else
	cPar01	:= "Quantidade a Replicar"
	cMens01	:= "Copia Etiquetas da quantidade informada"
	cMens02	:= "Utilizado Somente para Notas Fiscais de Entrada !"
	cMens03	:= "Não pode ter mais de uma linha marcada !"
endif	

//Verifica opção que selecionou - Utilizado Somente para Notas fiscais de Entrada
if Substr(cCombo1,1,1) <> "1"
	msgAlert(cMens02)
	Return
endif	

For n:= 1 to Len(aWBrowse1)
	if aWBrowse1[n,1]
		nIt++
	endif	
	if nIt > 1
		msgAlert(cMens03)
		Return
	endif	
Next n

if nIt = 1
	aadd(aParamBox,{1,cPar01,0,"@E 999" ,,,"",50  ,.F.}) 
	If ParamBox(aParamBox,cMens01,,,,,,,,cPerg,.T.,.T.)
		For i:= 1 to Len(aWBrowse1)
		
			if aWBrowse1[i,1]
				
				cTipeB1:= Alltrim(Posicione("SB1",1,xFilial("SB1") + Alltrim(aWBrowse1[i,2]) ,"B1_TIPE"))
				
				For r:= 1 to mv_par01
	
					Aadd(aWBrowse1,	{	.f.				,;
										aWBrowse1[i,2]	,;
										aWBrowse1[i,3]	,;
										aWBrowse1[i,4]	,;
										aWBrowse1[i,5]	,;
										aWBrowse1[i,6]	,;
										aWBrowse1[i,7]	,;
										aWBrowse1[i,8]	,;
										aWBrowse1[i,9]	,;
										aWBrowse1[i,10]	,;
										aWBrowse1[i,11]	})
										
					RecLock("ZZH",.t.)
					ZZH->ZZH_COD	:= Alltrim(aWBrowse1[i,2]) 
					ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[i,3])
					ZZH->ZZH_DOC	:= cNumero
					ZZH->ZZH_SERIE	:= cSerie
					ZZH->ZZH_FORNEC	:= cCliFor
					ZZH->ZZH_LOJA	:= cLoja
					ZZH->ZZH_NOMEF	:= cNome
					ZZH->ZZH_ENTRA	:= dDataBase //dData	
					ZZH->ZZH_VALID	:= iif(cTipeB1 == "F", dDtaVal,CTOD("  /  /  "))	
					ZZH->ZZH_AUTIMP	:= cAutImp	
					ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[i,4])
					ZZH->ZZH_PERDA  := aWBrowse1[i,10]
					If Empty(ZZH->ZZH_INVIM1)
						ZZH->ZZH_INVIM1 := aWBrowse1[i,11]
					Else
						ZZH->ZZH_INVIM2 := aWBrowse1[i,11]
					EndIf
					Msunlock()									
			
				Next r
				aWBrowse1[i,1]:= .f.
			endif
		Next i	
		aSort(aWBrowse1,,, {|x, y| x[2] > y[2]})
	EndIf
endif

oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

fWBrowse(oWBrowse1,aWBrowse1,oDlg)

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Importa Pedido de Venda
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ImportaPed(aWBrowse1, oWBrowse1, oDlg ,cNumero, cSerie, cClifor, cLoja, cNome, dData, dDtaVal, cAutImp, cCombo)

Local cAliasSC9	:= GetNextAlias()
Local cQuery	:= ""
Local cMens01	:= ""
Local cMens02	:= ""
Local cMens03	:= ""
Local nQtdLib	:= 0
Local cLoteSc9	:= ""
Local cProdSc9	:= ""
Local nQuant	:= 0

if cIdioma == "SPANISH"
	cMens01	:= "Utilizado solo para Orden de Venta !"
	cMens02	:= "¡No hay orden liberada para orden informada!"
	cMens03	:= "A T E N C I Ó N"
elseif cIdioma == "ENGLISH"
	cMens01	:= "Used for Sales Order only !"
	cMens02	:= "There is no order released for informed order !"
	cMens03	:= "A T T E N T I O N"
else
	cMens01	:= "Utilizado Somente para Pedidos de Veda !"
	cMens02	:= "Não existe pedido item liberado para pedido informado !"
	cMens03	:= "A T E N Ç Ã O"	
endif	

if Substr(cCombo1,1,1) <> "2"
	msgAlert(cMens01)
	Return
endif	


If Select(cAliasSC9) > 0
	(cAliasSC9)->(DbCloseArea())
EndIf
 
cQuery:= " SELECT SC9.C9_PEDIDO, SC9.C9_ITEM, SC9.C9_CLIENTE, SC9.C9_LOJA, "+CRLF 
cQuery+= "        SC9.C9_DATALIB, SC9.C9_LOTECTL, SC9.C9_PRODUTO, SC9.C9_QTDLIB, "+CRLF
cQuery+= "        SB1.B1_DESC, SA1.A1_NOME "+CRLF 
cQuery+= " FROM " + RetSqlName( "SC9" ) + " SC9 "+CRLF

cQuery += "INNER JOIN" + CRLF
cQuery += "		" + RetSqlName("SB1") + " SB1 " + CRLF
cQuery += "ON" + CRLF
cQuery += "		SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND" + CRLF
cQuery += "		SB1.B1_COD = C9_PRODUTO 				 AND" + CRLF
cQuery += "		SB1.D_E_L_E_T_ = ' '" + CRLF

cQuery += "INNER JOIN" + CRLF
cQuery += "		" + RetSqlName("SA1") + " SA1 " + CRLF
cQuery += "ON" + CRLF
cQuery += "		SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND" + CRLF
cQuery += "		SA1.A1_COD  = C9_CLIENTE 				 AND" + CRLF
cQuery += "		SA1.A1_LOJA = C9_LOJA	 				 AND" + CRLF
cQuery += "		SA1.D_E_L_E_T_ = ' '" + CRLF

cQuery+= " WHERE C9_FILIAL  = '"+ xFilial("SC9")+ "'	AND "+CRLF
cQuery+= "       C9_PEDIDO	= '"+cNumero+"'				AND "+CRLF
cQuery+= "       C9_CLIENTE = '"+cClifor+"'				AND "+CRLF
cQuery+= "       C9_LOJA    = '"+cLoja+"'				AND "+CRLF
cQuery+= "       C9_NFISCAL = ''						AND "+CRLF
cQuery+= "       SC9.D_E_L_E_T_ = ' '  		                    "+CRLF
cQuery+= " ORDER BY C9_PRODUTO "+CRLF

TcQuery cQuery New Alias &cAliasSC9

TcSetField(cAliasSC9,"C9_DATALIB"  ,"D",8,0)

if !(cAliasSC9)->(Eof())
	
	While !(cAliasSC9)->(Eof())
	
		cLoteSc9:= (cAliasSC9)->C9_LOTECTL
		nQtdLib	:= (cAliasSC9)->C9_QTDLIB
		cProdSc9:= (cAliasSC9)->C9_PRODUTO
		nQuant	:= BuscaLote((cAliasSC9)->C9_PEDIDO, (cAliasSC9)->C9_ITEM, (cAliasSC9)->C9_CLIENTE, (cAliasSC9)->C9_LOJA, (cAliasSC9)->A1_NOME, (cAliasSC9)->C9_PRODUTO, (cAliasSC9)->B1_DESC, (cAliasSC9)->C9_LOTECTL, (cAliasSC9)->C9_QTDLIB)
		
		For i:= 1 to nQuant
			Aadd(aWBrowse1,	{	.f.				,;
								(cAliasSC9)->C9_PRODUTO	,;
								(cAliasSC9)->B1_DESC	,;
								(cAliasSC9)->C9_LOTECTL	,;
								(cAliasSC9)->C9_DATALIB	,;
								(cAliasSC9)->C9_CLIENTE	,;
								(cAliasSC9)->C9_LOJA	,;
								(cAliasSC9)->A1_NOME	})
											
		Next i									
	
		(cAliasSC9)->(dbSkip())
	enddo
else
	msgAlert(cMens02, cMens03)
endif

oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

fWBrowse(oWBrowse1,aWBrowse1,oDlg)

Return
 
 

/*
*/ 
Static Function BuscaLote( cPed, cItem, cCli, cLoj, cNome, cProdSc9, cDesc, cLoteSc9, nQtdLib )
 
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nQtd		:= 1


	
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQuery:= " SELECT R_E_C_N_O_   "+CRLF
cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF
cQuery+= "       ZZH_COD	= '" + cProdSc9 + "'		AND "+CRLF
cQuery+= "       ZZH_LOTE	= '" + cLoteSc9 + "'		AND "+CRLF
cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
cQuery+= " D_E_L_E_T_ = ' '  		                   		"+CRLF

TcQuery cQuery New Alias &cAlias

if !(cAlias)->(Eof())

	While !(cAlias)->(Eof())
	
		dbSelectArea("ZZH")
		ZZH->(dbGoto( (cAlias)->R_E_C_N_O_ ))
		RecLock("ZZH",.f.)
			ZZH->ZZH_PEDIDO	:= cPed
			ZZH->ZZH_ITEMPV	:= cItem
			ZZH->ZZH_CLIENT	:= cCli
			ZZH->ZZH_LOJAC	:= cLoj
			ZZH->ZZH_NOMEC	:= cNome
			ZZH->ZZH_COD	:= cProdSc9 
			ZZH->ZZH_DESC	:= cDesc
			ZZH->ZZH_SAIDA	:= dDataBase
		Msunlock()
		
		if nQtd = nQtdLib
			exit
		else	
			nQtd++
		endif	
		
		(cAlias)->(dbSkip())
		
	enddo	
endif	

(cAlias)->(dbCloseArea())
 
 Return(nQtd)

/*/{Protheus.doc} User Function MXPERDALT
	(long_description)
	@type User Function
	@author Ciro Pedreira
	@since 07/12/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	porqueria
	/*/
User Function MXPERDALT()

Local oWBrowse1
Local aWBrowse1		:= {}
Local oFont1
Local oDlg 
Local oGroup
Local aArea			:= GetArea()
Local cTitulo		:= ""      
Local nOpcao		:= 0
Local bNo			:= { || oDlg:End() }
Local bOk			:= { || oDlg:End(nOpcao:= 1) } 
Local aObjects 		:= {}
Local aPosObj  		:= {}
Local aSize			:= MsAdvSize()
Local aInfo    		:= {aSize[1],aSize[2],aSize[3],aSize[4],0,0}
Local cProduto		:= space(Len(SB1->B1_COD))
Local cLote			:= space(Len(ZZH->ZZH_LOTE))
Local aButtons		:= {}
Local _nL           := 0

Private lChk := .f.

Private cIdioma := __LANGUAGE

Private oOk	:= LoadBitmap(GetResources(),"LBOK")
Private oNo := LoadBitmap(GetResources(),"LBNO")

cTitulo:= if(cIdioma == "SPANISH","Reportar Pérdida",if(cIdioma == "ENGLISH","Report Loss","Informar perda"))
	
aadd( aObjects, { 100, 015, .T., .T. } )
aadd( aObjects, { 100, 085, .T., .T. } )
aPosObj  := MsObjSize( aInfo, aObjects, .T. )

//Faz o calculo automatico de dimensoes de objetos
oSize := FwDefSize():New(.T.)

oSize:lLateral	:= .F.
oSize:lProp		:= .T. // Proporcional

oSize:AddObject( "1STROW" ,  100, 37, .T., .T. ) // Totalmente dimensionavel
oSize:AddObject( "2NDROW" ,  100, 80, .T., .T. ) // Totalmente dimensionavel
oSize:AddObject( "3RDROW" ,  100, 10, .T., .T. ) // Totalmente dimensionavel
	
oSize:aMargins	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 

oSize:Process() // Dispara os calculos		

a2ndRow := {	oSize:GetDimension("2NDROW","LININI"),;
				oSize:GetDimension("2NDROW","COLINI"),;
				oSize:GetDimension("2NDROW","LINEND"),;
				oSize:GetDimension("2NDROW","COLEND")}

DEFINE MSDIALOG oDlg TITLE cTitulo From oSize:aWindSize[1],oSize:aWindSize[2] to oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL
oDlg:lMaximized := .T.

Define Font oFont1  Name "Arial Black" Size 0,-14 Bold    
Define Font oFont2  Name "Tahoma" Size 0,-12 Bold         
Define Font oFont3  Name "Arial Black" Size 0,-16 Bold    
 
*****************************************************************************************************
// Verifica o Idioma para exibicao
*****************************************************************************************************
if cIdioma == "SPANISH"
	cLabel1	:= "Tipo de Documento"
	cLabel2 := "Datos del documento"	
	cLabel3 := "Lea el Código de Barras"	
	cLabel4 := "Etiqueta Leida"
	cLabel5	:= "Impresión de la etiqueta"	
	cCampo1 := "Número"
	cCampo2	:= "Serie"
	cCampo3 := "CLIENTE/PROVEEDOR"
	cCampo4 := "TIENDA"
	cCampo5 := "NOMBRE"
	cCampo6 := "FECHA"
	cCampo7 := "P R O D U C T O"
	cCampo8	:= "L O T"
	cCampo9 := "Producto"
	cCampo10:= "Description"
	cCampo11:= "Lot"
	cCampo12:= "Fecha"
	cCampo13:= "Cliente/Proveedor"
	cCampo14:= "Tienda"
	cCampo15:= "Nombre"
	cCampo16:= "Caducidad"
	cCampo17:= "Aut.Importación:"
	cCampo18:= "Fecha de la Pérdida"
	cCampo19:= "Invima"
	cButton1:= "Elimina"
	cButton2:= "Filtro"
	cButton3:= "Impresión"
	cButton4:= "Replicar"
	cButton5:= "Orden de venta"
	cButton6:= "Fecha"
	cMensImp:= "¿Grabar fecha?"
	cImprime:= "Impresión..."
	
	
elseif cIdioma == "ENGLISH"
	cLabel1	:= "Document Type"
	cLabel2 := "Document Data"
	cLabel3 := "Read the Bar Code"
	cLabel4 := "Read Tag"
	cLabel5	:= "Label Printing"
	cCampo1 := "Number"
	cCampo2	:= "Series"
	cCampo3 := "CLIENT/PROVIDER"
	cCampo4 := "SHOP"
	cCampo5 := "NAME"
	cCampo6 := "DATE"
	cCampo7 := "P R O D U C T"
	cCampo8 := "L O T"
	cCampo9 := "Product"
	cCampo10:= "Description"
	cCampo11:= "Lot"
	cCampo12:= "Date"
	cCampo13:= "Client/Provider"
	cCampo14:= "Shop"
	cCampo15:= "Name"
	cCampo16:= "Expiry"
	cCampo17:= "Aut.Import:"
	cCampo18:= "Date Loss"
	cCampo19:= "Invima"
	cButton1:= "Deleta"
	cButton2:= "Filter"
	cButton3:= "Printing"
	cButton4:= "Replicate"
	cButton5:= "Sales order"
	cButton6:= "Date"
	cMensImp:= "Record date?"
	cImprime:= "Printing..."	
	
	
else
	cLabel1	:= "Tipo de Documento"
	cLabel2 := "Dados do Documento"
	cLabel3 := "Leia o Código de Barras"
	cLabel4 := "Etiqueta Lida"
	cLabel5	:= "Impressão da Etiqueta"
	cCampo1	:= "Número"
	cCampo2	:= "Série"
	cCampo3 := "CLIENTE/FORNECEDOR"
	cCampo4 := "LOJA"
	cCampo5 := "NOME"
	cCampo6 := "DATA"
	cCampo7 := "P R O D U T O"
	cCampo8 := "L O T E"
	cCampo9 := "Produto"
	cCampo10:= "Descrição"
	cCampo11:= "Lote"
	cCampo12:= "Data"
	cCampo13:= "Cliente/Fornecedor"
	cCampo14:= "Loja"
	cCampo15:= "Nome"
	cCampo16:= "Validade"
	cCampo17:= "Aut.Importação:"
	cCampo18:= "Data Perda"
	cCampo19:= "Invima"
	cButton1:= "Deleta"
	cButton2:= "Filtrar"
	cButton3:= "Imprime"
	cButton4:= "Replicar"
	cButton5:= "Pedido de Venda"
	cButton6:= "Data"
	cMensImp:= "Gravar data?"
	cImprime:= "Imprimindo..."
	
endif

@ aPosObj[1,1]+2 , aPosObj[1,2]+10 GROUP oGroup TO aPosObj[1,3]+2, aPosObj[1,4]-2 LABEL cLabel4 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+16, aPosObj[1,2]+20 SAY oSay8 PROMPT cCampo7		SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE 
@ aPosObj[1,1]+26 ,aPosObj[1,2]+20 MsGet oGet8  Var cProduto	SIZE 150, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cProduto)
@ aPosObj[1,1]+16, aPosObj[1,2]+180 SAY oSay8 PROMPT cCampo8 	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+26, aPosObj[1,2]+180 MsGet oGet9  Var cLote		SIZE 150, 010 Valid(fVldZZH(@cProduto,@cLote,aWBrowse1,oWBrowse1,oDlg,oGet8)) PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cLote)

// M&H
@ aPosObj[1,1]+26, aPosObj[1,2]+180 MsGet oGet9  Var cLote		SIZE 150, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cLote)
@ aPosObj[1,1]+36, aPosObj[1,2]+20 SAY oSay8 PROMPT cCampo19	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+46, aPosObj[1,2]+20 MsGet oGet10  Var cInvima	SIZE 150, 010 Valid(fVldZZH(@cProduto,@cLote,aWBrowse1,oWBrowse1,oDlg,oGet8)) PIXEL Of oDlg Font oFont2 F3 "SZ3" Color CLR_BLUE When Empty(cInvima)


oWBrowse1 := TCBrowse():New(a2ndRow[1]-20,a2ndRow[2]+10,a2ndRow[4]-65, a2ndRow[3]-85,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
oWBrowse1:AddColumn(TCColumn():New(" "					,{||If(Len(aWBrowse1)>0,If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),oNo)},	,,,"CENTER"	,,.T.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo9				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 2]," ")},PesqPict("SB1","B1_COD")			,,,"LEFT"	,70,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo10				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 3]," ")},PesqPict("SB1","B1_DESC")			,,,"LEFT"	,150,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo11				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 4]," ")},PesqPict("ZZH","ZZH_LOTE")		,,,"LEFT"	,60,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo12				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 5]," ")},PesqPict("SD1","D1_EMISSAO")		,,,"LEFT"	,50,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo13	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 6]," ")},PesqPict("SA1","A1_COD")			,,,"LEFT"	,60,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo14	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 7]," ")},PesqPict("SA1","A1_LOJA")			,,,"LEFT"	,30,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo15	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 8]," ")},PesqPict("SA1","A1_NOME")			,,,"LEFT"	,140,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo1	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 9]," ")},PesqPict("SF2","F2_DOC")			,,,"LEFT"	,140,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo2	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 10]," ")},PesqPict("SF2","F2_SERIE")		,,,"LEFT"	,140,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo18	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 11]," ")},PesqPict("SF2","F2_EMISSAO")		,,,"LEFT"	,140,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo19	,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 12]," ")},PesqPict("ZZH","ZZH_INVIM1")		,,,"LEFT"	,160,.F.,.F.,,,,.F.,))


oChkBox:= TCheckBox():New(aPosObj[2,3]-15, aPosObj[1,2]+13, "Marca/Desmarca Todos", bSetGet(lChk), oDlg, 080, 020,, {|| MarcaTodos(aWBrowse1,oWBrowse1,lChk,oDlg)})

@ a2ndRow[1]-20,a2ndRow[4]-45 BUTTON cButton6 SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action (fDtPerda(aWBrowse1, oWBrowse1, oDlg))

fWBrowse(oWBrowse1,aWBrowse1,oDlg)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bNo,Nil,aButtons) CENTERED

if nOpcao = 1

	if Len(aWBrowse1) > 0

		If MsgYesNo(cMensImp)
			
			For _nL := 1 To Len(aWBrowse1)

				If aWBrowse1[_nL][1] // Se o registro estiver marcado.
					
					ZZH->(DBGoTo(aWBrowse1[_nL][12])) // Posição do RECNO é a 12 neste momento.
					
					RecLock('ZZH', .F.)
						ZZH->ZZH_PERDA := aWBrowse1[_nL][11] // Posição da data da perda é a 11 neste momento.
					ZZH->(MSUnlock())

				EndIf

			Next _nL

		EndIf
		
	else
		if cIdioma == "SPANISH"
			msgAlert("La fecha no se puede escribir, ya que no se lee etiqueta","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Date can not be written because it has not been Read Label","A T T E N T I O N")
		else
			msgAlert("Data não pode ser gravada, pois não foi Lido Etiqueta","A T E N Ç Ã O")
		endif
	endif
else
	lContinua:= .F.
endif

RestArea(aArea)

Return

/*/{Protheus.doc} fVldZZH
	(long_description)
	@type Static Function
	@author Ciro Pedreira
	@since 07/12/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function fVldZZH(cProduto,cLote,aWBrowse1,oWBrowse1,oDlg,oGet8)

Local _lRet   := .T.
Local cCodigo := ''
Local cCodLoj := ''
Local cNome   := ''

If Empty(cLote) .Or. Empty(cProduto)
	MsgAlert("Informe el lote y el producto!","A T E N C I Ó N")
	
	cLote    := Space(Len(ZZH->ZZH_LOTE))
	cProduto := Space(Len(SB1->B1_COD))
	_lRet    := .F.

	oGet8:Setfocus()
	oGet8:Refresh()
Else
	ZZH->(DBSetOrder(2)) // Indice 2 - ZZH_FILIAL+ZZH_COD+ZZH_LOTE+ZZH_NUMETQ
	If ZZH->(DBSeek(xFilial('ZZH')+cProduto+cLote))
		While ZZH->(!EOF()) .And. ZZH->ZZH_FILIAL == xFilial('ZZH') .And. ZZH->ZZH_COD == cProduto .And.;
		ZZH->ZZH_LOTE == cLote

			If !Empty(ZZH->ZZH_FORNEC)
				cCodigo := ZZH->ZZH_FORNEC
				cCodLoj := ZZH->ZZH_LOJA
				cNome   := ZZH->ZZH_NOMEF
			Else
				cCodigo := ZZH->ZZH_CLIENT
				cCodLoj := ZZH->ZZH_LOJAC
				cNome   := ZZH->ZZH_NOMEC
			EndIf

			AAdd(aWBrowse1,	{	.F.						,;
								ZZH->ZZH_COD			,;
								AllTrim(ZZH->ZZH_DESC)	,;
								ZZH->ZZH_LOTE			,;
								ZZH->ZZH_ENTRA			,;
								cCodigo					,;
								cCodLoj					,;
								cNome					,;
								ZZH->ZZH_DOC			,;
								ZZH->ZZH_SERIE			,;
								ZZH->ZZH_PERDA			,;
								ZZH->(Recno())			})

			ZZH->(DBSkip())
		EndDo
	EndIf
EndIf

oDlg:Refresh()
oWBrowse1:Refresh()

Return _lRet

/*/{Protheus.doc} fDtPerda
	(long_description)
	@type Static Function
	@author Ciro Pedreira
	@since 09/12/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function fDtPerda(aWBrowse1, oWBrowse1, oDlg)

Local _nL        := 0
Local _nPDtPerd  := 11 // Posição da coluna de Data da Perda.
Local _dData     := CToD('//')
Local _aParamBox := {}
Local _aRet      := {}
Local lCentered := .T. // Indica se centraliza a janela.
Local nPosX     := C(150) // Coordenada X da janela.
Local nPosy     := C(005) // Coordenada y da janela.
Local lCanSave  := .F. // Indica se pode salvar o arquivo com respostas.
Local lUserSave := .T. // Configuracao por usuario.
Local cCadastro := 'Fecha de la pérdida'

AAdd(_aParamBox, {1, OemToAnsi("Fecha"), _dData, "", "", "", "", C(050), .T.})

If ParamBox(_aParamBox, cCadastro, @_aRet,,, lCentered, nPosX, nPosy,,, lCanSave, lUserSave)
	
	_dData := _aRet[1]

	For _nL := 1 To Len(aWBrowse1)

		If aWBrowse1[_nL][1] // Se o registro estiver marcado.
			aWBrowse1[_nL][_nPDtPerd] := _dData
		EndIf

	Next _nL

EndIf

fWBrowse(oWBrowse1, aWBrowse1, oDlg)

Return

/*/{Protheus.doc} CODINVIMA
	Verifica se o código INVIMA está vigente, caso não esteja, pega um novo código no cadastro de produtos.
	@type Static Function
	@author Ciro Pedreira
	@since 15/12/2020
	@version version
	@param _cCodPro1, C, Código do produto.
	@param _cCodInv1, C, Código INVIMA.
	@return _aRet, A, Vetor com duas posições: [1] = .T. para código INVIMA válido ou .F. para código INVIMA inválido. [2] = Código INVIMA válido.
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function CODINVIMA(_cCodPro1, _cCodInv1)

	Local _aAreaSB1 := SB1->(GetArea())
	Local _aAreaSZ3 := SZ3->(GetArea())
	Local _cRetInv  := ''
	Local _aRet     := {}
	Local _lOk      := .F.

	SZ3->(DBSetOrder(1)) // Indice 1 - Z3_FILIAL+Z3_COD
	If SZ3->(DBSeek(xFilial('SZ3')+_cCodInv1))

		If SZ3->Z3_VIGENCI < dDataBase // Caso a validade do INVIMA esteja vencida.

			_lOk := .F.

			SB1->(DBSetOrder(1)) // Indice 1 - B1_FILIAL+B1_COD
			If SB1->(DBSeek(xFilial('SB1')+_cCodPro1))

				SZ3->(DBSetOrder(1)) // Indice 1 - Z3_FILIAL+Z3_COD
				If SZ3->(DBSeek(xFilial('SZ3')+SB1->B1_ZZINVIM)) // Verifica se o código INVIMA no Produto está vigente.

					If SZ3->Z3_VIGENCI < dDataBase // Caso a validade do INVIMA esteja vencida.

						_cRetInv := ''

					Else

						_cRetInv := SB1->B1_ZZINVIM
						_lOk     := .T.

					EndIf

				EndIf

			EndIf

		Else

			_cRetInv := _cCodInv1 // Se o INVIMA estiver vigente, utiliza o mesmo código.
			_lOk     := .T.
			
		EndIf

	EndIf

	_aRet := {_lOk, _cRetInv}

	RestArea(_aAreaSB1)
	RestArea(_aAreaSZ3)

Return _aRet

/*/{Protheus.doc} VENCINVI()
	Valida a vigencia do código INVIMA;
	@type User Function
	@author Ciro Pedreira
	@since 16/12/2020
	@version version
	@return _lRet, L, .T. = INVIMA válido ou .F. = INVIMA vencido.
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function VENCINVI()

	Local _lRet    := .T.
	Local _cMsgInv := "Código INVIMA inválido o caducado."
	
	SZ3->(DBSetOrder(1)) // Indice 1 - Z3_FILIAL+Z3_COD
	If SZ3->(DBSeek(xFilial('SZ3')+M->B1_ZZINVIM))

		If SZ3->Z3_VIGENCI < dDataBase // Caso a validade do INVIMA esteja vencida.
			
			MsgAlert(_cMsgInv, 'Alerta')

			_lRet := .F.

		EndIf

	Else

		MsgAlert(_cMsgInv, 'Alerta')

		_lRet := .F.
		
	EndIf

Return _lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValDtInv ºAutor  ³ALVARO HURTADO 		ºFecha ³  09/02/2022  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar a data do Invima do produto                        º±±
±±º          ³      													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Colombia\ Ottobock		                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValDtInv(cCodInv)
Local lRet 	:= .F.
Local cMsg	:= ""

If !Empty(cCodInv)
	
	SZ3->(DBSetOrder(1))
	If SZ3->(DBSeek(xFilial("SZ3")+cCodInv))
		If SZ3->Z3_VIGENCI < dDataBase
			lRet := .F.
			cMsg := "El código Invima '"+cCodInv+"' está con fecha de validez vencida (" + DTOC(SZ3->Z3_VIGENCI) +")"
			Aviso("MxRastrea \ A T E N C I Ó N",cMsg,{"OK"})
		Else
			lRet := .T.
		EndIf
	Endif
Endif

Return(lRet)
