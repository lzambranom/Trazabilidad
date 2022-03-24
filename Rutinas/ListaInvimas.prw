#INCLUDE "PROTHEUS.CH"

User Function ShowInvimas()

Local aAreaSZ3 := GetArea("SZ3")
Local cCodInvim:= "   "
Local aInvimas := {}
Local cVarQ    := ''
Local cCodInvima := ''

ChkFile("SZ3")
DbSelectArea("SZ3")
DbSetOrder(1)
DbGotop()
While !SZ3->(EOF())
   
	If SZ3->Z3_FILIAL == xFilial("SZ3")  // .AND. SZ3->Z3_VIGENCI >= "FECHA ACTUAL" 
     	AADD( aInvimas,{SZ3->Z3_COD, SZ3->Z3_VIGENCI} )
	EndIf
	SZ3->(DbSkip())
	
EndDo

If Len(aInvimas) > 0
	
		DEFINE MSDIALOG oDlgSerie TITLE "Listado Invimas" From 3,0 to 340,550 PIXEL
		@ .5,.80 LISTBOX oSeri VAR cVarQ Fields HEADER "Cod. Invima","Fec. Vigencia" SIZE  267,145 NOSCROLL
		oSeri:SetArray(aInvimas)
		oSeri:bLine := { || {aInvimas[oSeri:nAT,1],aInvimas[oSeri:nAT,2]}}
		//DEFINE SBUTTON FROM 153,230 TYPE 1 ACTION (llenarCp(aSolAbier[oSeri:nAT,1]),oDlgSerie:End()) ENABLE OF oDlgSerie
		//DEFINE SBUTTON FROM 153,230 TYPE 1 ACTION (llenarCp(aInvimas[oSeri:nAT,1]),oDlgSerie:End()) ENABLE OF oDlgSerie
        DEFINE SBUTTON FROM 153,230 TYPE 1 ACTION (cCodInvima := aInvimas[oSeri:nAT,1],oDlgSerie:End()) ENABLE OF oDlgSerie
        ACTIVATE MSDIALOG oDlgSerie
        
Endif

SZ3->(DbCloseArea()	)

RestArea(aAreaSZ3)

Return(cCodInvima)       

 /*/{Protheus.doc} llenarCp
    (long_description)
    @type  Function
    @author user
    @since 13/05/2020
    @version version
    @param cCodSol, caracter, cod de la solcitud
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
/*    
Static Function llenarCp(cCodInvima)
Local aArexZZJ  := GetArea("SZ3")

    DbSelectArea("SZ3")
    DbSetOrder(1)
    dbSeek(cCodInvima,.F.)

        M->cInvima      := 	SZ3->Z3_COD
        M->C5_VEND1   :=  ZZJ->ZZJ_CODVEN  
        M->C5_LOJA		:=	ZZJ->ZZJ_LOJA
		M->C5_ZZORTOP	:=	ZZJ->ZZJ_CODORT   
		M->C5_XPDCLIE	:=	ZZJ->ZZJ_PEDCLI
		M->C5_ZZPACIE	:=	ZZJ->ZZJ_IDPACI
		M->C5_XPDCLIE	:=	ZZJ->ZZJ_PEDCLI  
		M->C5_XSOLIC	:=	ZZJ->ZZJ_NUMSOL
        M->C5_LOJACLI	:=	ZZJ->ZZJ_LOJA
        M->C5_CLIENT    := 	ZZJ->ZZJ_CODEPS
        M->C5_LOJAENT	:=	ZZJ->ZZJ_LOJA
        M->C5_ZZNCLIE   :=  POSICIONE("SA1",1,XFILIAL("SA1") +ZZJ->ZZJ_CODEPS + ZZJ->ZZJ_LOJA,"A1_NOME" ) 
        M->C5_ZZNCLEN   :=  POSICIONE("SA1",1,XFILIAL("SA1") +ZZJ->ZZJ_CODEPS + ZZJ->ZZJ_LOJA,"A1_NOME" ) 
        M->C5_CONDPAG   :=  POSICIONE("SA1",1,XFILIAL("SA1") +ZZJ->ZZJ_CODEPS + ZZJ->ZZJ_LOJA,"A1_COND" )
		
    SZ3->(DbCloseArea()	)
RestArea(aArexSZ3)
Return
*/
