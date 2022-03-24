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
User Function ColRastrea() 

Local aArea:= GetArea()
Local lContinua:= .t.

While lContinua

	MontaTela(@lContinua)

enddo


RestArea(aArea)

Return


Static Function MontaTela(lContinua)

Local oWBrowse1
Local aWBrowse1		:= {}
Local oFont1
Local oDlg 
Local oGroup
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
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
Local dData			:= CTOD("  /  / ")
Local lOkEtq		:= .t.
Local lFiltra		:= .f.
Local dDtaFab		:= dDataBase
//Local nNumEtq		:= 0
Local lRet			:= .t.


//Private oGet1, oGet2, oGet3, oGet4, oGet5, oGet6, oGet7,oGet8,oGet9,oGet10

Private lPrdNotExist:= .f.
Private lImpEtq		:= GetMv("ZZ_IMPETIQ")
Private cIdioma 	:= __LANGUAGE

Private aTipoOps:= if(cIdioma == "SPANISH",{'Entrada','Salida'},if(cIdioma == "ENGLISH",{'Input','Output'},{'Entrada','Saída'}))
Private aTipoMov:= if(cIdioma == "SPANISH",{'Nota Fiscal de Entrada','Orden de venta','O.P.'},if(cIdioma == "ENGLISH",{'Incoming Invoice','Sales order','PO'},{'Nota Fiscal de Entrada','Pedido de Venda','OP'}))

cTitulo:= if(cIdioma == "SPANISH","Trazabilidad de los productos",if(cIdioma == "ENGLISH","Product Traceability","Rastreabilidade de Produtos"))

Private lRadio		:= .t.
Private nRadio		:= 1
Private oOk		 	:= LoadBitmap(GetResources(),"LBOK")
Private oNo		 	:= LoadBitmap(GetResources(),"LBNO")
	
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
	cCampo1 := "NÚMERO"
	cCampo2	:= "SERIE"
	cCampo3 := "CLIENTE/PROVEEDOR"
	cCampo4 := "TIENDA"
	cCampo5 := "NOMBRE"
	cCampo6:= "FECHA"
	cCampo7 := "P R O D U C T O"
	cCampo8	:= "L O T"
	cCampo9 := "Producto"
	cCampo10:= "Description"
	cCampo11:= "Lot"
	cCampo12:= "Fecha"
	cCampo13:= "Cliente/Proveedor"
	cCampo14:= "Tienda"
	cCampo15:= "Nombre"
	cButton1:= "Elimina"
	cButton2:= "Filtro"
	cButton3:= "Impresión"
	cMensImp:= "¿Desea imprimir el informe ?"
	cImprime:= "Printing..."
	
elseif cIdioma == "ENGLISH"
	cLabel1	:= "Document Type"
	cLabel2 := "Document Data"
	cLabel3 := "Read the Bar Code"
	cLabel4 := "Read Tag"
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
	cButton1:= "Deleta"
	cButton2:= "Filter"
	cButton3:= "Printing"
	cMensImp:= "Do you want to print Report ?"
	cImprime:=  "Impresión..."
	
else
	cLabel1	:= "Tipo de Documento"
	cLabel2 := "Dados do Documento"
	cLabel3 := "Leia o Código de Barras"
	cLabel4 := "Etiqueta Lida"
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
	cButton1:= "Deleta"
	cButton2:= "Filtrar"
	cButton3:= "Imprime"
	cMensImp:= "Deseja imprimir Relatório ?"
	cImprime:=  "Imprimindo..."
endif 
                                        
@ aPosObj[1,1]+2, aPosObj[1,2]+3 GROUP oGroup TO aPosObj[1,3]+8,aPosObj[1,1]+90 LABEL cLabel1 OF oDlg PIXEL Color CLR_BLUE

oRadio:= TRadMenu():New(aPosObj[1,1]+13, aPosObj[1,2]+10, aTipoMov,{|u|Iif (PCount()==0,nRadio,nRadio:=u)} , oDlg,,,,,,,{|u|lRadio}, 70, 12,,, .T.)

cCombo1:= aTipoOps[1]
oCombo1 := TComboBox():New(aPosObj[1,1]+30,aPosObj[1,1]+48,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
aTipoOps,36,20,oDlg,,,,,,.T.,,,,,,,,,'cCombo1') //{||fVldop(@oDlg,nRadio)}

@ aPosObj[1,1]+2, aPosObj[1,1]+95 GROUP oGroup TO aPosObj[1,3]+8,aPosObj[1,4]-2 LABEL cLabel2 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+13, aPosObj[1,1]+98 SAY 	 oSay1 PROMPT cCampo1   				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+98 MsGet oGet1  Var cNumero					 	SIZE 060, 010 Valid !Empty(cNumero) .and. (fVldNum(oDlg,cNumero,@cClifor, @cLoja, @cNome, @dData, oWBrowse1, oDlg )) PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When .t.
@ aPosObj[1,1]+13, aPosObj[1,1]+160 SAY 	oSay2 PROMPT cCampo2  	 			SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+160 MsGet oGet2  Var cSerie					 	SIZE 030, 010 Valid(fVldDoc(oDlg,cNumero,cSerie)) PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When nRadio = 1  
@ aPosObj[1,1]+13, aPosObj[1,1]+195 SAY 	 oSay3 PROMPT cCampo3			 	SIZE 070, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+195 MsGet oGet3  Var cCliFor				 	SIZE 070, 010 PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When Empty(cClifor) .and. (nRadio = 1 .or. nRadio = 2)   
@ aPosObj[1,1]+13, aPosObj[1,1]+270 SAY 	 oSay4 PROMPT cCampo4 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+270 MsGet oGet4  Var cLoja					 	SIZE 030, 010 Valid(fDados(cNumero, cSerie, @cClifor, @cLoja, @dData,@cNome,oDlg)) PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When Empty(cLoja) .and. (nRadio = 1 .or. nRadio = 2)
@ aPosObj[1,1]+13, aPosObj[1,1]+305 SAY 	 oSay5 PROMPT cCampo5 				SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+305 MsGet oGet5  Var cNome					 	SIZE 180, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .f. //nRadio = 1 .or. nRadio = 2 
@ aPosObj[1,1]+13, aPosObj[1,1]+530 SAY 	 oSay6 PROMPT cCampo6 			  	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+23 ,aPosObj[1,1]+530 MsGet oGet6  Var dData					 	SIZE 060, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When .f.

@ aPosObj[1,1] + 60 , aPosObj[1,2]+3 GROUP oGroup TO aPosObj[1,3]+60, aPosObj[1,1]+190 LABEL cLabel3 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+78 ,aPosObj[1,2]+10 MsGet oGetcEtiqueta  Var cEtiqueta			SIZE 200, 010 Valid (fVldEtq(@lOkEtq,@cEtiqueta,@cProduto,@cLote,@aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, @lRadio, lFiltra, dData) )PIXEL Of oDlg PICTURE "@!" Font oFont2 Color CLR_BLUE When lOkEtq //!Empty(cEtiqueta) .and.

@ aPosObj[1,1] + 60 , aPosObj[1,2]+230 GROUP oGroup TO aPosObj[1,3]+60, aPosObj[1,4]-2 LABEL cLabel4 OF oDlg PIXEL Color CLR_BLUE
@ aPosObj[1,1]+73, aPosObj[1,2]+240 SAY 	 oSay8 PROMPT cCampo7			   	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE 
@ aPosObj[1,1]+83 ,aPosObj[1,2]+240 MsGet oGet8  Var cProduto					SIZE 150, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cProduto)  
@ aPosObj[1,1]+73, aPosObj[1,2]+400 SAY oSay8 PROMPT cCampo8	 			 	SIZE 080, 010 PIXEL Of oDlg Font oFont2 Color CLR_BLUE
@ aPosObj[1,1]+83, aPosObj[1,2]+400 MsGet oGet9  Var cLote						SIZE 150, 010 Valid(fVldLote(@lOkEtq,@cEtiqueta,@cProduto,@cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lRadio, lFiltra, dData)) PIXEL Of oDlg Font oFont2 Color CLR_BLUE When Empty(cLote)

oWBrowse1 := TCBrowse():New(a2ndRow[1]+30,a2ndRow[2]+10,a2ndRow[4]-65, a2ndRow[3]-135,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,.T.)//oPanel2
oWBrowse1:AddColumn(TCColumn():New(" "					,{||If(Len(aWBrowse1)>0,If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),oNo)},	,,,"CENTER"	,,.T.,.F.,,,,.F.,))	
oWBrowse1:AddColumn(TCColumn():New(cCampo9				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 2]," ")},PesqPict("SB1","B1_COD")			,,,"LEFT"	,70,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo10				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 3]," ")},PesqPict("SB1","B1_DESC")			,,,"LEFT"	,150,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo11				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 4]," ")},PesqPict("ZZH","ZZH_LOTE")		,,,"LEFT"	,60,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo12				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 5]," ")},PesqPict("SD1","D1_EMISSAO")		,,,"LEFT"	,50,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo13				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 6]," ")},PesqPict("SA1","A1_COD")			,,,"LEFT"	,60,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo14				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 7]," ")},PesqPict("SA1","A1_LOJA")			,,,"LEFT"	,30,.F.,.F.,,,,.F.,))
oWBrowse1:AddColumn(TCColumn():New(cCampo15				,{||If(Len(aWBrowse1)>0,aWBrowse1[oWBrowse1:nAT, 8]," ")},PesqPict("SA1","A1_NOME")			,,,"LEFT"	,140,.F.,.F.,,,,.F.,))

@ a2ndRow[1]+30,a2ndRow[4]-40 BUTTON cButton1 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action (fDeletaItem(aWBrowse1, oWBrowse1, oDlg, lFiltra, nRadio, cNumero, cSerie, cCliFor, cLoja))
@ a2ndRow[1]+70,a2ndRow[4]-40 BUTTON cButton2 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action (fFiltrar(@aWBrowse1, oWBrowse1, oDlg, nRadio, cNumero, cSerie, cCliFor, cLoja, @lOkEtq, @lFiltra))
@ a2ndRow[1]+110,a2ndRow[4]-40 BUTTON cButton3 			SIZE 40, 20 OF oDlg PIXEL  Font oFont2 Action fImprime(aWBrowse1,lFiltra)

*************************************************************************************************************************************************************************************************
                                                   
fWBrowse(oWBrowse1,aWBrowse1,oDlg) 


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bNo,Nil) CENTERED  


if nOpcao = 1 .and. !lFiltra

	if Len(aWBrowse1) > 0

		If MsgYesNo(cMensImp)
			if nRadio = 1 //Nota Fiscal de Entrada
				//Processa({||U_RelNotaCo(cNumero, cSerie, cClifor, cLoja, cNome, dData)})
				Processa({||U_RelNotaMx(cNumero, cSerie, cClifor, cLoja, cNome, dData)})
			elseif nRadio = 2 // Pedido de Venda
				//Processa({||U_RELPEDCo(cNumero, cClifor, cLoja, cNome, dData)})
				Processa({||U_RELPEDMX(cNumero, cClifor, cLoja, cNome, dData)})
			elseif nRadio = 3  // Ordem de Produçao
				if Substr(cCombo1,1,1) $ "E/I"
					//Processa({||U_RELOPECo(cNumero, dData)})
					Processa({||U_RELOPEMX(cNumero, dData)})
				else
					//Processa({||U_RELOPSCo(cNumero, dData)})
					Processa({||U_RELOPSMX(cNumero, dData)})
				endif
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

	oWBrowse1:nScrollType := 1
	//oWBrowse1:SetFocus()
	oWBrowse1:Refresh()

Return

                                                                                                                                      
//////////////////////////////////////////////////////////////////////////////////////////////////
//Valida Dodos do Cabeçalho
//////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDados(cNumero, cSerie, cClifor, cLoja, dData,cNome,oDlg)

Local lRet:= .t.
Local lAchou:= .f.
 
if nRadio = 1 //Nota Fiscal de Entrada
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
			
			cNumero	:= space(Len(SF2->F2_DOC)) 
			cCliFor	:= space(Len(SA1->A1_COD))
			cLoja	:= space(Len(SA1->A1_LOJA))
			lRet:= .f.
		else
			dData:= SF1->F1_EMISSAO		
			cNome:= Alltrim(SA2->A2_NOME)
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
elseif nRadio = 2 // Pedido de Venda
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
elseif nRadio = 3  // Ordem de Produça
	cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])
	cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
	if Substr(cCombo1,1,1) $ "E/I"
		SD3->(dbSetOrder(1))
		if SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
			lAchou:= .t.
			dData:= SD3->D3_EMISSAO	
		endif
	else
		SD4->(dbSetOrder(1))
		if SD4->(dbSeek(xFilial("SD4")+cProduto+Alltrim(cNumero)))
			lAchou:= .t.
			dData:= SD4->D4_DATA	
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
		cNumero	:= space(Len(SF2->F2_DOC)) 
		cCliFor	:= space(Len(SA1->A1_COD))
		cLoja	:= space(Len(SA1->A1_LOJA))
		lRet:= .f.
	endif	
endif	

oDlg:Refresh()

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldEtq(lOkEtq,cEtiqueta,cProduto,cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lRadio, lFiltra, dData)

Local lRet		:= .t.
Local lAchouPed	:= .t.
Local nTamEtq	:= Len(Alltrim(cEtiqueta)) 
Local nPriPipe	:= At("|",cEtiqueta)
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

if nPipeLote > 0
	cLote:= Substr(cLote,1,nPipeLote)
endif	 
	
if Empty(cProduto)
	cProduto	:= space(Len(SB1->B1_COD))
	cLote		:= space(Len(ZZH->ZZH_LOTE))
	cEtiqueta	:= Space(60)
	Return(.t.)
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
			lAchouProd:= .f.
		else
			cProduto:= SB1->B1_COD
		endif
	endif
		
	if lAchouProd
	
		if nRadio = 1 //Nota Fiscal de Entrada
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
									0						})
			else
				lOkEtq:= .f.
				lRet:= .f.
			endif
				
		elseif nRadio = 2 // Pedido de Venda
		
			if !Empty(cProduto)
				lAchouPed:= fQryPed(Alltrim(cNumero),cProduto)
			else
				lAchouPed:=.f.
			endif	
			
			if lAchouPed
				if !Empty(cLote)
								
					nRegZZH:= fBuscaEtq(cProduto,cLote)
					
					if nRegZZH > 0
						lRet:= .t.
						Aadd(aWBrowse1,	{	.f.						,;
											cProduto				,;
											Alltrim(SB1->B1_DESC)	,;
											cLote					,;
											dDataBase				,;
											cCliFor					,;
											cLoja					,;
											cNome					,;
											0						})
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
		
		elseif nRadio = 3 // Ordem de Produção
			cProduto:= padr(Alltrim(cProduto),tamSx3("B1_COD")[1])
			cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
			if Substr(cCombo1,1,1) $ "E/I"
				cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
				SD3->(dbSetOrder(1))
				if SD3->(dbSeek(xFilial("SD3")+cNumero+cProduto))
					lAchou:= .t.
				endif
			else
				SD4->(dbSetOrder(1))
				if SD4->(dbSeek(xFilial("SD4")+cProduto+Alltrim(cNumero)))
					lAchou:= .t.
				endif
			endif	
			if lAchou
				if !Empty(cLote)

					if Substr(cCombo1,1,1) $ "E"
					
						Aadd(aWBrowse1,	{	.f.						,;
											cProduto				,;
											Alltrim(SB1->B1_DESC)	,;
											cLote					,;
											dDataBase				,;
											cCliFor					,;
											cLoja					,;
											cNome					,;
											0						})
					else
						nRegZZH:= fBuscaEtq(cProduto,cLote)
					
						if nRegZZH > 0

							Aadd(aWBrowse1,	{	.f.						,;
												cProduto				,;
												Alltrim(SB1->B1_DESC)	,;
												cLote					,;
												dDataBase				,;
												cCliFor					,;
												cLoja					,;
												cNome					,;
												0						})
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
		endif
	else
		if !Empty(cProduto)
			if nRadio = 1
				If MsgYesNo("Producto No existe ! Desea grabar el producto?","A T E N C I Ó N")
					lPrdNotExist:= .t.
				endif
				lRet:= .f.
			else
				msgAlert("Producto no existe en el registro !","A T E N C I Ó N")	
					
				lRet:= .f.
				cEtiqueta	:= Space(60)	
				cProduto	:= space(Len(SB1->B1_COD))
				cLote		:= space(Len(ZZH->ZZH_LOTE))
				oDlg:Refresh()
				oGetcEtiqueta:Refresh()
				oGetcEtiqueta:Setfocus()
			endif	
		else
			lRet:= .f.
			oDlg:Refresh()
			fWBrowse(oWBrowse1,aWBrowse1,oDlg)
		endif
	endif	
	if lRet
		cProduto	:= space(Len(SB1->B1_COD))
		cLote		:= space(Len(ZZH->ZZH_LOTE))
		cEtiqueta	:= Space(60)
		lRadio		:= .f.
		oDlg:Refresh()
	endif
endif

if lRet
	GravaZZH(aWbrowse1, cNumero, cSerie, cClifor, cLoja, cNome, lRadio, lFiltra, dData)
	
	oDlg:Refresh()
	fWBrowse(oWBrowse1,aWBrowse1,oDlg)
	
	oDlg:Refresh()
	oGetcEtiqueta:Setfocus()
	oGetcEtiqueta:Refresh()
	
endif	

Return//(lRet)


//////////////////////////////////////////////////////////////////////////////////////////////////
//Grava Etiquetas Lidas na Tabela ZZH
//////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaZZH(aWBrowse1, cNumero, cSerie, cClifor, cLoja, cNome, lRadio, lFiltra, dData)

Local nNumEtq:= 0
Local cResponsavel	:= SuperGetMV("ZZ_RESPON",,"") 
Local cCrea			:= SuperGetMV("ZZ_CREA",,"")
Local nRecZZH		:= 0


if Len(aWBrowse1) > 0
	
	For iTens:= Len(aWBrowse1) to Len(aWBrowse1)
		if !Empty(aWBrowse1[iTens,4])
			
			if nRadio = 1 //Nota Fiscal de Entrada
				RecLock("ZZH",.t.)
				ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
				ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
				ZZH->ZZH_DOC	:= cNumero
				ZZH->ZZH_SERIE	:= cSerie
				ZZH->ZZH_FORNEC	:= cCliFor
				ZZH->ZZH_LOJA	:= cLoja
				ZZH->ZZH_NOMEF	:= cNome
				ZZH->ZZH_ENTRA	:= dData	
				ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
				Msunlock()
			elseif nRadio = 2 // Pedido de Venda
	
				cProduto:= padr(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
				cLote	:= padr(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
				
				nRecZZH:= fBuscaEtq(cProduto,cLote)		
				
				if nRecZZH > 0
				
					dbSelectArea("ZZH")
					ZZH->(dbGoto(nRecZZH))
					RecLock("ZZH",.f.)
						ZZH->ZZH_PEDIDO	:= cNumero
						ZZH->ZZH_CLIENT	:= cClifor
						ZZH->ZZH_LOJAC	:= cLoja
						ZZH->ZZH_NOMEC	:= cNome
						ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
						ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
						ZZH->ZZH_SAIDA	:= dDataBase
					Msunlock()
				else
					msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
				endif	
					
			elseif nRadio = 3  // Ordem de Produçao
			
				if Substr(cCombo1,1,1) $ "E/I"
					RecLock("ZZH",.t.)
					ZZH->ZZH_OP		:= cNumero
					ZZH->ZZH_COD	:= Alltrim(aWBrowse1[iTens,2]) 
					ZZH->ZZH_DESC	:= Alltrim(aWBrowse1[iTens,3])
					ZZH->ZZH_ENTRA	:= dData	
					ZZH->ZZH_LOTE	:= Alltrim(aWBrowse1[iTens,4])
					Msunlock()
				else
					cNumero := padr(Alltrim(cNumero),tamSx3("ZZH_OP")[1])
					cProduto:= padr(Alltrim(aWBrowse1[iTens,2]),tamSx3("B1_COD")[1])
					cLote	:= padr(Alltrim(aWBrowse1[iTens,4]),tamSx3("ZZH_LOTE")[1])
				
					nRecZZH:= fBuscaEtq(cProduto,cLote)		
				
					if nRecZZH > 0
				
						dbSelectArea("ZZH")
						ZZH->(dbGoto(nRecZZH))
						RecLock("ZZH",.f.)
						ZZH->ZZH_OP		:= cNumero
						ZZH->ZZH_SAIDA	:= aWBrowse1[iTens,5]
						Msunlock()
					else
						msgAlert("No hay Saldo para Grabar Etiqueta !","A T E N C I Ó N")
					endif
				
				endif	
			endif
			aWBrowse1[iTens,9]:= ZZH->(Recno())
			
			if lImpEtq .and. nRadio = 1 .or. (nRadio = 3 .and. Substr(cCombo1,1,1) $ "E/I") .and. !lFiltra
				U_ETQANVCO(Alltrim(aWBrowse1[iTens,2]) , dDataBase, Alltrim(aWBrowse1[iTens,4]) )
			endif
			
		endif	
	Next iTens
endif

Return



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldLote(lOkEtq,cEtiqueta,cProduto,cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lRadio, lFiltra, dData)

Local lLote	:= .f.
Local cMesAt:= ""

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
			GrvNotExist( cNumero, cSerie, cClifor, cLoja, cNome, lRadio, cProduto , dData, cLote)
			cProduto	:= space(Len(SB1->B1_COD))
			cLote		:= space(Len(ZZH->ZZH_LOTE))
			cEtiqueta	:= Space(60)
			oGetcEtiqueta:Setfocus()
			oGetcEtiqueta:Refresh()
			lPrdNotExist:= .f.
		else	
			cEtiqueta:= Alltrim(cProduto) + "|" + Alltrim(cLote)
			fVldEtq(lOkEtq,cEtiqueta,cProduto,cLote,aWBrowse1,oWBrowse1,cNumero, cSerie, cClifor, cLoja, cNome, oDlg, lRadio, lFiltra, dData)
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
Static Function fQryPed(cNumero,cProduto)

Local lPed		:= .t.
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQuery:= " SELECT C9_PEDIDO, C9_PRODUTO, C9_NFISCAL "+CRLF 
cQuery+= " FROM " + RetSqlName( "SC9" ) + "  "+CRLF
cQuery+= " WHERE C9_FILIAL  = '"+ xFilial("SC9")+ "'	AND "+CRLF
cQuery+= "       C9_PEDIDO	= '"+cNumero+"'				AND "+CRLF
cQuery+= "       C9_PRODUTO = '"+cProduto+"'			AND "+CRLF
//cQuery+= "       C9_NFISCAL = ''						AND "+CRLF
cQuery+= "       D_E_L_E_T_ = ' '  		                    "+CRLF

TcQuery cQuery New Alias &cAlias

if (cAlias)->(Eof())
	if cIdioma == "SPANISH"
		msgAlert("Producto no existe en el pedido o no ha sido liberado !","A T E N C I Ó N")	
	elseif cIdioma == "ENGLISH"
		msgAlert("Product Not in Order or Not Released !","A T T E N T I O N")	
	else
		msgAlert("Produto Não existe no Pedido ou Não foi Liberado !","A T E N Ç Ã O")	
	endif	
	lPed:= .f.
endif	

Return(lPed)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldDoc(oDlg,cNumero,cSerie)

Local lRetDoc:= .t.

if nRadio = 1 // Nota de Entrada
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
elseif nRadio = 2
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
elseif nRadio = 3
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
		cNumero	:= spac(13) //space(Len(SF1->F1_DOC))
		lRetDoc:= .f.
	endif
endif	
	
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
Static Function fDeletaItem(aWBrowse1, oWBrowse1, oDlg, lFiltra, nRadio, cNumero, cSerie, cCliFor, cLoja)

Local aWBrAux:= {}

For i:= 1 to Len(aWBrowse1)

	if !aWBrowse1[i,1]
		Aadd(aWBrAux,	{	.f.				,;
							aWBrowse1[i,2]	,;
							aWBrowse1[i,3]	,;
							aWBrowse1[i,4]	,;
							aWBrowse1[i,5]	,;
							aWBrowse1[i,6]	,;
							aWBrowse1[i,7]	,;
							aWBrowse1[i,8]	,;
							aWBrowse1[i,9]	})
	else
		//if lFiltra
			fExclui(nRadio, aWBrowse1[i,9])
		//endif						
	endif
	
Next i

aWBRowse1:= {}
fWBrowse(oWBrowse1,aWBrowse1,oDlg)

aWBRowse1:= aClone(aWBrAux)

oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

fWBrowse(oWBrowse1,aWBrowse1,oDlg)

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Valida Numero digitado. Somente para Pedido de Venda e Ordem de Produçã, pois para Nota Fiscal de Entrada já está
//validando no campo Série.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fVldNum(oDlg,cNumero,cClifor, cLoja, cNome,dData, oWBrowse1, oDlg )

Local lRetNum:= .t.
Local lAchou := .f.

if nRadio = 2 // Pedido de Venda
	SC9->(dbSetOrder(1))
	If !SC9->(dbSeek(xFilial("SC9")+Alltrim(cNumero)))
		if cIdioma == "SPANISH"
			msgAlert("Solicitud de venta no ha sido liberado !","A T E N C I Ó N")
		elseif cIdioma == "ENGLISH"
			msgAlert("Sales order was not released !","A T T E N T I O N")
		else
			msgAlert("Pedido de Venda não foi Liberado !","A T E N Ç Ã O")
		endif	
		cNumero	:= space(Len(SF1->F1_DOC))
		lRetNum:= .f.
	else
		SA1->(dbSetOrder(1))
		if SA1->(dbSeek(xFilial("SA1")+SC9->(C9_CLIENTE+C9_LOJA)))
			cCliFor	:= SC9->C9_CLIENTE
			cLoja	:= SC9->C9_LOJA
			cNome	:= Alltrim(SA1->A1_NOME)
			dData	:= SC9->C9_DATALIB
		endif	
	endif	
elseif nRadio = 3 // Ordem de Produção
	if Substr(cCombo1,1,1) $ "E/I"
		cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
		SD3->(dbSetOrder(1))
		if SD3->(dbSeek(xFilial("SD3")+cNumero))
			lAchou:= .t.
			dData:= SD3->D3_EMISSAO	
		endif
	else
		cNumero := padr(Alltrim(cNumero),tamSx3("D3_OP")[1])
		SD4->(dbSetOrder(2))
		if SD4->(dbSeek(xFilial("SD4")+cNumero))
			lAchou:= .t.
			dData:= SD4->D4_DATA	
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
endif

oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 

Return(lRetNum)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Filtra Ítens da Nota Fiscal Lidos anteriormente
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fFiltrar(aWBrowse1, oWBrowse1, oDlg, nRadio, cNumero, cSerie, cCliFor, cLoja, lOkEtq, lFiltra)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local cCodigo	:= ""
Local cCodLoj	:= ""
Local cNome		:= ""

if Len(aWBrowse1) > 0
	Return
endif
	
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQuery:= " SELECT ZZH_COD, ZZH_DESC, ZZH_ENTRA, ZZH_LOTE, ZZH_FORNEC, ZZH_LOJA,  "+CRLF
cQuery+= "        ZZH_NOMEF, ZZH_CLIENT, ZZH_LOJAC, ZZH_NOMEC, ZZH_NUMETQ, R_E_C_N_O_ "+CRLF 
cQuery+= " FROM " + RetSqlName( "ZZH" ) + "  "+CRLF
cQuery+= " WHERE ZZH_FILIAL  = '"+ xFilial("ZZH")+ "'	AND "+CRLF

if nRadio = 1 //Nota Fiscal de Entrada
	cQuery+= "       ZZH_DOC		= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_SERIE	= '"+cSerie+"'				AND "+CRLF
	cQuery+= "       ZZH_FORNEC	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJA	= '"+cLoja+"'				AND "+CRLF
elseif nRadio = 2 //Pedido de Venda	
	cQuery+= "       ZZH_PEDIDO	= '"+cNumero+"'				AND "+CRLF
	cQuery+= "       ZZH_CLIENT	= '"+cCliFor+"'				AND "+CRLF
	cQuery+= "       ZZH_LOJAC	= '"+cLoja+"'				AND "+CRLF
elseif nRadio = 3 //Ordem de Produção
	cQuery+= "       ZZH_OP = '"+cNumero+"'					AND "+CRLF
endif
cQuery+= " D_E_L_E_T_ = ' '  		                   			 "+CRLF

TcQuery cQuery New Alias &cAlias

TCSetField( (cAlias), "ZZH_ENTRA"	, "D")

(cAlias)->(dbGotop())

While !(cAlias)->(eof())

	if nRadio = 1 
		cCodigo	:= (cAlias)->ZZH_FORNEC
		cCodLoj	:= (cAlias)->ZZH_LOJA
		cNome	:= (cAlias)->ZZH_NOMEF
	elseif nRadio = 2	
		cCodigo	:= (cAlias)->ZZH_CLIENT
		cCodLoj	:= (cAlias)->ZZH_LOJAC
		cNome	:= (cAlias)->ZZH_NOMEC
	elseif nRadio = 3
		if Substr(cCombo1,1,1) $ "E/I"
			cCodigo	:= (cAlias)->ZZH_FORNEC
			cCodLoj	:= (cAlias)->ZZH_LOJA
			cNome	:= (cAlias)->ZZH_NOMEF
		endif
	endif	
	 	
	Aadd(aWBrowse1,	{	.f.							,;
						(cAlias)->ZZH_COD			,;
						Alltrim((cAlias)->ZZH_DESC)	,;
						(cAlias)->ZZH_LOTE			,;
						(cAlias)->ZZH_ENTRA			,;
						cCodigo						,;
						cCodLoj						,;
						cNome						,;
						(cAlias)->R_E_C_N_O_		})

	(cAlias)->(dbSkip())
enddo	

lOkEtq	:= .f.
lFiltra	:= .t.
	
oWBrowse1:Refresh()			// Refresh do Grid
oDlg:Refresh() 
fWBrowse(oWBrowse1,aWBrowse1,oDlg)

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Exclui Registro ZZH
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fExclui(nRadio, nNumRec )

if nRadio = 1 .or. (nRadio = 3 .and. Substr(cCombo1,1,1) $ "E")	
	dbSelectArea("ZZH")
	ZZH->(dbGoto(nNumRec))
	Reclock("ZZH", .f.)
	ZZH->(dbdelete())
	ZZH->(MSUnlock())
elseif nRadio = 2 	
	dbSelectArea("ZZH")
	ZZH->(dbGoto(nNumRec))
	Reclock("ZZH", .f.)
	ZZH->ZZH_PEDIDO	:= ""
	ZZH->ZZH_CLIENT	:= ""
	ZZH->ZZH_LOJAC	:= ""
	ZZH->ZZH_NOMEC	:= ""
	ZZH->ZZH_SAIDA	:= CTOD("  /  /  ")
	ZZH->(MSUnlock())
elseif nRadio = 3 .and. Substr(cCombo1,1,1) $ "S"
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
if nRadio = 2 //Pedido de Venda
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
elseif nRadio = 3 .and. Substr(cCombo1,1,1) $ "S" //Ordem de Produção
	cQuery+= "       ZZH_COD	= '" + cProduto + "'		AND "+CRLF
	cQuery+= "       ZZH_LOTE	= '" + cLote + "'			AND "+CRLF
	cQuery+= "       ZZH_OP = ''							AND "+CRLF
	cQuery+= "       ZZH_PEDIDO	= ''						AND "+CRLF
endif
cQuery+= " D_E_L_E_T_ = ' '  		                   			 "+CRLF

TcQuery cQuery New Alias &cAlias

if !(cAlias)->(Eof())
	nRec:= (cAlias)->R_E_C_N_O_
endif	

Return(nRec)


Static Function GrvNotExist( cNumero, cSerie, cClifor, cLoja, cNome, lRadio, cProduto , dData, cLote)

if nRadio = 1 //Nota Fiscal de Entrada
	RecLock("ZZH",.t.)
	ZZH->ZZH_COD	:= cProduto 
	ZZH->ZZH_DESC	:= "******** No hay registro *********"
	ZZH->ZZH_DOC	:= cNumero
	ZZH->ZZH_SERIE	:= cSerie
	ZZH->ZZH_FORNEC	:= cCliFor
	ZZH->ZZH_LOJA	:= cLoja
	ZZH->ZZH_NOMEF	:= cNome
	ZZH->ZZH_ENTRA	:= dData	
	ZZH->ZZH_LOTE	:= cLote
	ZZH->ZZH_NUMETQ	:= ""
	Msunlock()
endif

Return

/*
Reimpressão da Etiqueta
*/
Static Function fImprime(aWBrowse1,lFiltra)

if lImpEtq .and. nRadio = 1 .or. (nRadio = 3 .and. Substr(cCombo1,1,1) $ "E/I") .and. !lFiltra
	For x:= 1 to Len(aWBrowse1)
		if aWBrowse1[x,1]
			U_ETQANVCO(Alltrim(aWBrowse1[x,2]) , dDataBase, Alltrim(aWBrowse1[x,4]),"" ,"" ,0 ,0 , cIdioma )
		endif	
	Next x
else
	msgAlert("Impresión de etiquetas sólo para entradas !","A T E N C I Ó N")	
endif

Return